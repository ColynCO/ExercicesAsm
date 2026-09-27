#include <iostream>

# define PI 3.14159265358979323846 

struct Point { float x, y, z; };
struct Shape { Point* points; int pointCount = 0; };

extern "C" int32_t asm_findTen(int32_t* arr, int32_t _count, int32_t _value);

extern "C" void asm_addPoint(Shape* _shape, Point _newPoint);
extern "C" void asm_rotateShapeYaw(Shape* _shape, float _rotation);
extern "C" double asm_sin(double _val);
extern "C" float asm_fsin(float _val);
extern "C" double asm_cos(double _val);
extern "C" float asm_fcos(float _val);

void ShowShape(Shape _shape)
{
	for (int i = 0; i < _shape.pointCount; i++)
	{
		std::cout << i + 1 << ": " <<
			_shape.points[i].x << ", " <<
			_shape.points[i].y << ", " <<
			_shape.points[i].z << std::endl;
	}
}

int main()
{
	srand(time(nullptr));
	/*int32_t array[16];
	for (int i = 0; i < 16; i++)
	{
		array[i] = rand() % 10+1;
		std::cout << array[i] << " ";
	}
	std::cout << std::endl;
	std::cout << asm_findTen(array, 16, 6) << std::endl;*/

	Shape shape;
	shape.points = (Point*)malloc(12 * 3);

	asm_addPoint(&shape, Point(1, 0, 0));
	asm_addPoint(&shape, Point(0, 1, 0));
	asm_addPoint(&shape, Point(0, 0, 1));
	ShowShape(shape);

	double val = PI / 2.0;

	asm_rotateShapeYaw(&shape, val);
	ShowShape(shape);

	std::cout << "Assembly" << std::endl;
	std::cout << "sin(" << val << ") = " << asm_sin(val) << std::endl;
	std::cout << "cos(" << val << ") = " << asm_cos(val) << std::endl;

	std::cout << "fsin(" << val << ") = " << asm_fsin((float)val) << std::endl;
	std::cout << "fcos(" << val << ") = " << asm_fcos((float)val) << std::endl;
	
	std::cout << "Cpp" << std::endl;
	std::cout << "sin(" << val << ") = " << sin(val) << std::endl;
	std::cout << "cos(" << val << ") = " << cos(val) << std::endl;

	return 0;
}
