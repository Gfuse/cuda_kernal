#include <iostream>
#include <cuda.h>
#include <cuda_runtime.h>
#define gpuErrchk(ans) { gpuAssert((ans), __FILE__, __LINE__); }
inline void gpuAssert(cudaError_t code, const char *file, int line, bool abort=true)
{
   if (code != cudaSuccess)
   {
      fprintf(stderr,"GPUassert: %s %s %d\n", cudaGetErrorString(code), file, line);
      if (abort) exit(code);
   }
}

__global__ void add(int *a, int *b, int *c) {
  *c = *a + *b;
  printf("Hello, world from the device!\n");
}



int main(){

  int a, b, c=0; // host copies of a, b, c
  int *d_a, *d_b, *d_c; // device copies of a, b, c
  int size = sizeof(int);
  // Allocate space for device copies of a, b, c
  cudaMalloc((void **)&d_a, size);
  cudaMalloc((void **)&d_b, size);
  cudaMalloc((void **)&d_c, size);
  // Setup input values
  a = 2;
  b = 7;
  // Copy inputs to device
  cudaMemcpy(d_a, &a, size, cudaMemcpyHostToDevice);
  cudaMemcpy(d_b, &b, size, cudaMemcpyHostToDevice);
  add<<<1,1>>>(d_a, d_b, d_c);
  // Copy result back to host
  cudaMemcpy(&c, d_c, size, cudaMemcpyDeviceToHost);
  std::cout<<c<<'\n';
  // Cleanup
  cudaFree(d_a); cudaFree(d_b); cudaFree(d_c);
  return 0;

}
