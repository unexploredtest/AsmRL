# AsmRL
Reinforcement learning done in assembly.
Basically a simplified implementation of tabular Q-learning algorithm for an easy 8x8 grid world in Armv7. Why? Good question.

## Build
just run make:
```sh
make
```
and run with:
```sh
./main
```

If your host machine doesn't support Armv7, then just run it with qemu:
```sh
qemu-arm ./main
```