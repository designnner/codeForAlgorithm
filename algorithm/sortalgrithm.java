
//交换函数
public static void swap(int[] nums,int i,int j){
  int temp = num[i];
  nums[i] = nums[j];
  nums[j] = temp;
}

//冒泡排序 (未优化)
public static void bubblesort(int[] nums){
  int i,j;
  for(i=nums.length-1;i>=0;i--){
    for(j=0;j<i;j++){
      if(nums[j]>nums[j+1]) swap(nums,j,j+1);
    }
  }
}

//冒泡排序 （优化）
public static void bubblesort(int[] nums){
  int i,j;
  boolean flag = false;
  for(i=nums.length-1;i>=0;i--){
    for(j=0;j<i;j++){
      if(nums[j]>nums[j+1]) {
        swap(nums,j,j+1);
        flag = true;
      }
    }
    if(!flag) break;
  }
}

//选择排序
public static void selectsort(int[] nums){
  int i,j;
  int min;
  for(i=0;i<nums.length-1;i++){
    min = i;
    for(j=i+1;j<nums.length;j++){
      if(nums[j]<nums[min]){
        min = j;
      }
    }
    if(min!=i)
      swap(nums,i,min);
  }
}

//插入排序
public static void insertsort(int[] nums){
  int index,value;
  for(int i=1;i<nums.length;i++){
    index = i;
    value = nums[i];
    while(index>0&&nums[index-1]>value){
      nums[index] = nums[index-1];
      index--;
    }
    nums[index] = value;
  }
}

//归并排序
public static void mergesort(int[] nums ,int i,int j){
  if(i>=j) return;
  int mid = (i+j)/2;
  mergesort(nums,i,mid);
  mergesort(nums,mid+1,j);
  
  //使用数组记录i到j的数
  int[] temp = new int[j-i+1];
  for(int k = i;k<=j;k++){
    temp[k-i] = nums[k];
  }
  
  int mark1 = 0,mark2 = mid-i+1;
  for(int k=i;k<=j;k++){
    if(mark1==(mid-i+1)) nums[k] = temp[mark2++];
    else if(mark2==(j-i+1)||temp[mark1]<temp[mark2]) nums[k] = temp[mark1++];
    else nums[k] = temp[mark2++];
  }

}

//快速排序
public static int partition(int[] nums ,int l,int r){
  int left =l,right=r;
  while(left<right){
    while(left<right&&nums[right]>=nums[l]) right--;
    while(left<right&&nums[left]<=nums[l]) left++;
    swap(nums,left,right);
  }
  swap(nums,l,left);
  return left;

}
public static void quicksort(int[] nums ,int l,int r){
  if(l>=r) return ;
  int i = partition(nums,l,r);
  quicksort(nums,l,i-1);
  quicksort(nums,i+1,r);
}

//堆排序
public static void maxheap(int[] nums,int size,int curr){
  int left = curr*2+1;
  int right = left+1;
  int maxIndex = curr;
  if(left<size&&nums[left]>nums[maxIndex]) maxIndex = left;
  if(right<size&&nums[right]>nums[maxIndex]) maxIndex = right;
  if(maxIndex!=curr){
    swap(nums,curr,maxIndex);
    maxheap(nums,size,maxIndex);
  }

}
public static void buildMaxHeap(int[] nums){
  int mid = nums.length/2;
  for(int i=mid;i>=0;i--){
    maxheap(nums,nums.length,i);
  }
}

public static void heapsort(int[] nums){
  buildMaxHeap(nums);
  for(int i=nums.length-1;i>=1;i--){
    swap(nums,0,i);
    maxheap(nums,i,0);
  }

}

//桶排序
public static void bucketsort(int[] nums){
        //计算数组中的最大值和最小值
        int max = Integer.MIN_VALUE;
        int min = Integer.MAX_VALUE;
        for(int i=0;i<nums.length;i++){
            max = Math.max(max,nums[i]);
            min = Math.min(min,nums[i]);
        }
        int num = (max-min)/nums.length+1;
        List<List<Integer>> bucket = new ArrayList<List<Integer>>(num);
        for(int i=0;i<num;i++){
            bucket.add(new ArrayList<Integer>());
        }
        for(int i=0;i<nums.length;i++){
            int index = (nums[i]-min)/nums.length;
            bucket.get(index).add(nums[i]);
        }
        for(int i=0;i<num;i++){
            Collections.sort(bucket.get(i), new Comparator<Integer>() {
                public int compare(Integer o1, Integer o2) {
                    return o2-o1;
                }
            });
        }
        int index=0;
        for(int i=0;i<num;i++){
            for(int j=0;j<bucket.get(i).size();j++){
                nums[index++]=bucket.get(i).get(j);
            }
        }
    }
