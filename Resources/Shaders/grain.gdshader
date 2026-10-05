shader_type canvas_item;

uniform sampler2D screen_texture : hint_screen_texture, filter_linear_mipmap;
uniform float grain_intensity : hint_range(0.0, 0.5) = 0.12;
uniform float time_scale : hint_range(0.0, 2.0) = 0.7;

float noise(vec2 p) {
    return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

vec3 soft_light(vec3 base, vec3 blend) {
    vec3 result;
    for (int i = 0; i < 3; i++) {
        float b = blend[i];
        float a = base[i];
        if (b < 0.5) {
            result[i] = 2.0 * a * b + a * a * (1.0 - 2.0 * b);
        } else {
            result[i] = 2.0 * a * (1.0 - b) + sqrt(a) * (2.0 * b - 1.0);
        }
    }
    return result;
}

void fragment() {
    vec3 color = texture(screen_texture, SCREEN_UV).rgb;

    float lum = dot(color, vec3(0.299, 0.587, 0.114));
    float factor = 1.0 - smoothstep(0.0, 0.7, lum); // stronger in shadows

    vec2 offset = vec2(sin(TIME * time_scale), cos(TIME * time_scale * 1.3)) * 15.0;
    vec2 n_uv = UV + offset;

    // Colored grain
    float n_r = noise(n_uv);
    float n_g = noise(n_uv + vec2(0.17, 0.31));
    float n_b = noise(n_uv + vec2(0.41, 0.07));
    vec3 grain = vec3(n_r, n_g, n_b) * 2.0 - 1.0;

    grain *= grain_intensity * factor;

    // Soft-light blend looks more natural than just adding
    vec3 grain_color = clamp(vec3(0.5) + grain, 0.0, 1.0);
    color = soft_light(color, grain_color);

    COLOR = vec4(color, 1.0);
}