#[compute]
#version 450

layout(local_size_x = 8, local_size_y = 8, local_size_z = 1) in;

layout(set = 2, binding = 0, rgba8) readonly uniform image2D solve_image;

layout(set = 1, binding = 0, rgba8) uniform image2D output_image;

layout(set = 0, binding = 0, std430) restrict buffer ParameterBuffer {
    float data[];
} params;

layout(set = 0, binding = 1, std430) restrict buffer CountBuffer {
    int cleanCount;
} count;

void main() {
    float radius = params.data[0];
    ivec2 image_dims = imageSize(output_image);
    ivec2 pixel_coord = ivec2(gl_GlobalInvocationID.xy);

    for (int i = 1; i < (params.data[1] + 1); i++) {
        vec2 center_point = vec2(params.data[i * 2], params.data[i * 2 + 1]);
        if (pixel_coord.x >= image_dims.x || pixel_coord.y >= image_dims.y) {
            return;
        }

        float dist = distance(vec2(pixel_coord) + vec2(0.5), center_point);

        if (dist < radius) {
            imageStore(output_image, pixel_coord, vec4(0.0, 0.0, 0.0, 1.0));
        }
    }
    if (imageLoad(solve_image, pixel_coord) == vec4(0.0, 0.0, 0.0, 1.0) && imageLoad(output_image, pixel_coord) == vec4(0.0, 0.0, 0.0, 1.0))
    {
        atomicAdd(count.cleanCount, 1);
    }
}
