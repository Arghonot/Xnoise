#ifndef LIBNOISE_SHADER_UTILS
#define LIBNOISE_SHADER_UTILS
// --- to calculate 3d coordinates from uvs
float3 GetSphericalCoordinatesRad(float Ln, float Lat, float radius)
{
	Ln *= 360;
	Lat *= 180;
	Ln -= 180;
	Lat -= 90;
	Ln *= 0.017453292519943295;
	Lat *= 0.017453292519943295;

	return float3(
		radius * cos(Lat) * sin(Ln),
		radius * cos(Lat) * cos(Ln),
		radius * sin(Lat));
}
#endif