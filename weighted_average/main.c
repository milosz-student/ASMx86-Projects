#include <stdio.h>

float weighted_average(float* data_array, float* weight_array, unsigned int n);

int main()
{
	unsigned int n = 10;
	float data_array[10] = { 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0 };
	float weight_array[10] = { 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0 };

	float result = weighted_average(&data_array, &weight_array, n);
	printf("\n result of weighted average = %f\n", result);

return 0;
}