#ifndef LIBNOISE_SHADER_UTILS
#define LIBNOISE_SHADER_UTILS

// --- to calculate 3d coordinates from uvs

float3 GetPlanarCartesianFromUV(float2 uv, float3 origin)
{
		return float3(origin.x + uv.x, origin.y + uv.y, origin.z);
}

float3 GetSphericalCartesianFromUV(float Ln, float Lat, float radius)
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

float2 GetSphericalFromCartesian(float x, float y, float z)
{
	float r = sqrt(pow(x, 2) + pow(y, 2) + pow(z, 2));

	float ln = atan2(x, y) % 3.14159;
	float lat = asin(z / r) % 1.5708;

	return float2(ln, lat);
}

float2 GetUVFromSpherical(float ln, float lat)
{
	float2 uv = float2(ln, lat);

	uv.x = ((uv.x / 0.017453292519943295) + 180) / 360;
	uv.y = ((uv.y / 0.017453292519943295) + 90) / 180;

	return uv;
}

#endif