# Server Stats

A simple Bash script that can analyse basic server performance stats of a Linux server.

## Features

The script can display:

- Total CPU usage
- Memory usage (RAM and swap)
- Disk usage for the root partition (`/`)
- Top 5 processes by CPU usage
- Top 5 processes by memory usage

## Requirements

- Linux
- Bash
- Common system utilities:
  - `ps`
  - `awk`
  - `free`
  - `df`
  - `grep`
  - `head`
  - `tail`
  - `tr`

## Usage
```bash
./server-stats.sh [OPTIONS]
```

## Examples

Display all the stadistics

`./server-stats.sh`

The output should look like:

```bash
CPU usage is: 1% 

TYPE            TOTAL      USED             FREE            
Memory          7782068    5126076 (65%)    2655992 (35%)   
Swap            10485756   1808148 (17%)    8677608 (83%)   

TOTAL    USED         AVAILABLE   
295G     169G (61%)   111G (39%)  

PROCESS           CPU
qemu-system-x86 0.13%
brave           0.13%
brave           0.09%
gnome-shell     0.04%
gjs             0.04%

PROCESS         MEMORY
qemu-system-x86 18.4%
brave            6.5%
jetbrains-toolb  5.4%
gnome-software   4.6%
brave            3.8%
```
If I wanna show the top 5 processes consuming CPU I can use:

`./server-stats.sh -C`

The output should look like:

```bash
PROCESS           CPU
qemu-system-x86 0.13%
brave           0.10%
brave           0.09%
gnome-shell     0.04%
gjs             0.03%
```

## Autor
Developed by Brian Gelhorn. Project made for Roadmap.sh https://roadmap.sh/projects/server-stats

## License
This project is intended for educational and practice purposes.


