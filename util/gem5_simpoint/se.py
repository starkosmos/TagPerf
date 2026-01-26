import sys
import m5
from m5.objects import Root

from gem5.components.boards.riscv_board import RiscvBoard
from gem5.components.memory import DualChannelDDR4_2400
from gem5.components.processors.cpu_types import CPUTypes
from gem5.components.processors.simple_processor import SimpleProcessor
from gem5.isas import ISA
from gem5.resources.resource import BinaryResource
from gem5.simulate.exit_event import ExitEvent
from gem5.simulate.simulator import Simulator
from gem5.utils.requires import requires

# This runs a check to ensure the gem5 binary is compiled for RISCV.
requires(isa_required=ISA.RISCV)

# With RISCV, we use simple caches.
from gem5.components.cachehierarchies.classic.private_l1_private_l2_walk_cache_hierarchy import (
    PrivateL1PrivateL2WalkCacheHierarchy,
)

# Here we setup the parameters of the l1 and l2 caches.
cache_hierarchy = PrivateL1PrivateL2WalkCacheHierarchy(
    l1d_size="16KiB", l1i_size="16KiB", l2_size="256KiB"
)

# Memory: Dual Channel DDR4 2400 DRAM device.
memory = DualChannelDDR4_2400(size="16GiB")

# Here we setup the processor. We use a simple processor.
processor = SimpleProcessor(
    cpu_type=CPUTypes.O3, isa=ISA.RISCV, num_cores=1
)

# Here we setup the board.
board = RiscvBoard(
    clk_freq="3GHz",
    processor=processor,
    memory=memory,
    cache_hierarchy=cache_hierarchy,
)
board.processor.cores[0].core.max_insts_any_thread = 1_000_000_000
board.processor.cores[0].core.max_insts_all_threads = 1_200_000_000

# Run the simulation
if len(sys.argv) == 1:
    print("Please provide SE workload")
    exit(-1)
board.set_se_binary_workload(
    binary=BinaryResource(local_path=sys.argv[1]),
    arguments=sys.argv[2:]
)

def handler():
    m5.stats.reset()
    print("Warm-up for 1 billion instructions finished.")
    yield False
    yield True

simulator = Simulator(
    board=board,
    on_exit_event={
        ExitEvent.MAX_INSTS: handler()
    }
)
simulator.run()
