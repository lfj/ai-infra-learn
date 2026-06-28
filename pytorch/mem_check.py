import argparse

import torch

GiB = 1024 ** 3


def _format_gib(num_bytes: int) -> str:
    return f"{num_bytes / GiB:.2f} GiB"


def print_cuda_stats(device_id: int | None = None, reset_peak: bool = False) -> None:
    device_ids = [device_id] if device_id is not None else list(range(torch.cuda.device_count()))

    for idx in device_ids:
        device = torch.device(f"cuda:{idx}")
        name = torch.cuda.get_device_name(device)

        allocated = torch.cuda.memory_allocated(device)
        reserved = torch.cuda.memory_reserved(device)
        peak_allocated = torch.cuda.max_memory_allocated(device)
        peak_reserved = torch.cuda.max_memory_reserved(device)

        print(f"GPU {idx} ({name})")
        print(f"  当前占用 (allocated): {_format_gib(allocated)}")
        print(f"  缓存预留 (reserved):  {_format_gib(reserved)}")
        print(f"  峰值占用 (allocated): {_format_gib(peak_allocated)}")
        print(f"  峰值预留 (reserved):  {_format_gib(peak_reserved)}")

        if reset_peak:
            torch.cuda.reset_peak_memory_stats(device)
            print("  峰值统计已重置")


def print_mps_stats() -> None:
    if not hasattr(torch.mps, "current_allocated_memory"):
        print("当前 PyTorch 版本不支持 MPS 显存统计")
        return

    allocated = torch.mps.current_allocated_memory()
    driver = torch.mps.driver_allocated_memory()

    print("Apple MPS")
    print(f"  当前占用 (allocated): {_format_gib(allocated)}")
    print(f"  驱动占用 (driver):    {_format_gib(driver)}")


def main() -> None:
    parser = argparse.ArgumentParser(description="查看 PyTorch GPU 显存占用")
    parser.add_argument(
        "--device",
        type=int,
        default=None,
        help="指定 CUDA 设备编号，默认打印所有可用 GPU",
    )
    parser.add_argument(
        "--reset-peak",
        action="store_true",
        help="打印后重置 CUDA 峰值统计，便于后续测量新的峰值",
    )
    args = parser.parse_args()

    if torch.cuda.is_available():
        if args.device is not None and args.device >= torch.cuda.device_count():
            raise SystemExit(f"设备 cuda:{args.device} 不存在，共 {torch.cuda.device_count()} 张 GPU")
        print_cuda_stats(device_id=args.device, reset_peak=args.reset_peak)
    elif torch.backends.mps.is_available():
        if args.device is not None or args.reset_peak:
            print("MPS 不支持 --device / --reset-peak 参数，已忽略")
        print_mps_stats()
    else:
        raise SystemExit("CUDA 和 MPS 均不可用")


if __name__ == "__main__":
    main()
