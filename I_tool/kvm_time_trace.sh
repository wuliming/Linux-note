#!/bin/sh
output=$2
input=$1
export LANG=c
awk '
 BEGIN{
 entry=0;
 kvmexit=0;
 sum_guest=0;
 sum_external=0;
 sum_host=0;
 flag=0
 flag1=0
}
{ 
  if(flag == 1)
  {
    if($4 ~ /kvm_exit/) {
      kvmexit=$3
      printf("guset used_times: %12f - %12f =  %8.0f us\n", kvmexit, entry, (kvmexit-entry)*1000000);
      sum_guest += (kvmexit - entry)
      if($6 ~ /EXTERNAL_INTERRUPT/) {
         flag1=1
      }
    }
    else if($4 ~ /kvm_entry/) {
      entry=$3
      printf("host  used_times: %12f - %12f = %8.0f us\n", entry, kvmexit, (entry-kvmexit)*1000000);
      sum_host += (entry - kvmexit)
      if(flag1 == 1) {
         flag1 = 0 
         sum_external += (entry - kvmexit)
      }
    }
  }
  if(($4 ~ /kvm_entry/ ) && (flag == 0)) {
    flag++;
    entry=$3
    print entry
  }
}
END{
  printf("sum of guest is: %fs (%f%)\n", sum_guest, sum_guest/(sum_guest + sum_host)*100);
  printf("sum of host is: %fs (%f%)\n", sum_host, sum_host/(sum_guest + sum_host)*100);
  printf("sum of host(external) is: %fs (%f%)\n", sum_external, sum_external/(sum_guest + sum_host)*100);
  
}' > $output $input
