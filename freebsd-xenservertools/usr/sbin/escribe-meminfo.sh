#!/bin/sh

memoria_total_que_tiene=$(sysctl hw.physmem | cut -d ' ' -f2)
paginas_total_que_dispone=$(sysctl vm.stats.vm.v_page_count | cut -d ' ' -f2)
memoria_active_paginas=$(sysctl vm.stats.vm.v_active_count | cut -d ' ' -f2)
memoria_inactive_paginas=$(sysctl vm.stats.vm.v_inactive_count | cut -d ' ' -f2)
memoria_wire_paginas=$(sysctl vm.stats.vm.v_wire_count | cut -d ' ' -f2)
memoria_cache_paginas=$(sysctl vm.stats.vm.v_cache_count | cut -d ' ' -f2)
memoria_cache_paginas_comprometidas=$(echo "$memoria_cache_paginas / 2")
memoria_paginas_usadas=$(echo "$memoria_active_paginas + $memoria_inactive_paginas + $memoria_wire_paginas + $memoria_cache_paginas_comprometidas" | bc)
memoria_free_paginas=$(sysctl vm.stats.vm.v_free_count | cut -d ' ' -f2)
memoria_MB_total_que_dispone=$(echo "$paginas_total_que_dispone * 4 / 1024" | bc)
memoria_MB_usados=$(echo "$memoria_paginas_usadas * 4 /1024" | bc)
memoria_MB_libres=$(echo "$memoria_MB_total_que_dispone - $memoria_MB_usados" | bc)
memoria_KB_libres=$(echo "$memoria_MB_libres * 1024" | bc)
memoria_KB_total_que_dispone=$(echo "$memoria_MB_total_que_dispone * 1024" | bc)

echo "MemTotal:      $memoria_KB_total_que_dispone kB" > /procfalse/meminfo
echo "MemFree:       $memoria_KB_libres kB" >> /procfalse/meminfo