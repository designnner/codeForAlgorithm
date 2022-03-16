
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
