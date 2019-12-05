#include <mpi.h>
#include <iostream>

int main(int argc, char *argv[])
{
  int provided, size, rank, len;
  char name[MPI_MAX_PROCESSOR_NAME];

  MPI_Init(&argc, &argv);

  MPI_Comm_size(MPI_COMM_WORLD, &size);
  MPI_Comm_rank(MPI_COMM_WORLD, &rank);
  MPI_Get_processor_name(name, &len);

  std::cout <<
    "Hello, World! " <<
    "I am process "  << rank <<
    " of "           << size <<
    " on  "          << name <<
    "."              << std::endl;

  MPI_Finalize();
  return 0;
}
