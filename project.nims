task build, "build project":
  mkdir("out")
  exec "riscv32-unknown-elf-as -march=rv32imaczicsr_zifencei -mabi=ilp32 -g src/entry.s -o out/entry.o"
  exec "nim c --cpu:riscv32 --os:any --exceptions:goto --mm:arc --panics:on --threads:off -d:noSignalHandler --d:useMalloc -d:nimPage256 -d:danger --opt:size --listCmd --hint:cc --hint:link --nimcache:out/nimcache src/main.nim"

task clean, "clean project":
  rmdir("out")