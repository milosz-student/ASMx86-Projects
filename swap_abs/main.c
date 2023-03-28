#include <stdio.h>

void swap_abs(int array[], int n);

int main()
{
	int array[6] = { 5,4,2,1,-9 };
	int length = 6;

	for (int i = length; i > 0; i--) {
		swap_abs(array, length);
	}

	for (int i = 0; i < length; i++) {
		printf("%d ", array[i]);
	}

	printf("\nminimum : %d ", array[0]);
	printf("\nmaximum : %d ", array[length-1]);

	float median;
	if (length % 2 == 0) {
		median = (array[length / 2] + array[length / 2 -1 ]) / 2.0;
	}
	else {
		median = (array[length / 2]);
	}
	printf("\nmedian : %f ",median);

	return 0;
}
