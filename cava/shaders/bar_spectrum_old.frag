#version 330

in vec2 fragCoord;
out vec4 fragColor;

uniform float bars[512];
uniform int bars_count;
uniform int bar_width;
uniform int bar_spacing;
uniform vec3 u_resolution;
uniform vec3 bg_color;
uniform vec3 fg_color;
uniform int gradient_count;
uniform vec3 gradient_colors[8];

vec3 normalize_C(float y, vec3 col_1, vec3 col_2, float y_min, float y_max)
{
    float yr = (y - y_min) / (y_max - y_min);
    return col_1 * (1.0 - yr) + col_2 * yr;
}

void main()
{
    float x = u_resolution.x * fragCoord.x;
    int bar = int(bars_count * fragCoord.x);
    // float bar_size = u_resolution.x / float(bars_count);
    float bar_size = u_resolution.x / (float(bars_count) * 0.1);
    float y = bars[bar];

    // Ensure a minimum height
    if (y * u_resolution.y < 1.0)
    {
      y = 1.0 / u_resolution.y;
    }

    float threshold = 0.3;
    vec3 color = bg_color;
    float alpha = 0.1;
    float excess = (y - threshold) / (1.0 - threshold);
    float expansion = 1.0 + excess * 2.0; // Adjust this for more or less expansion

    if (y > threshold) {        
        //bar_size *= expansion;
        float center = (float(bar) + 0.5) * bar_size;
        float distance = abs(x - center);
        float max_distance = bar_size * 0.5 * expansion;
        
        if (distance < max_distance) {
            float glow_intensity = 1.0 - (distance / max_distance);
            glow_intensity = pow(glow_intensity, 2.0); // Adjust power for sharper or softer glow
            
            vec3 glow_color = vec3(0.5, 0.3, 1.0); // deep blue glow
            
            if (fragCoord.y < y) {
                // Inside the bar
                color = mix(fg_color, glow_color, glow_intensity * excess);
            } else {
                // Glow effect outside the bar
                color = mix(bg_color, glow_color, glow_intensity * excess * 0.5);
                alpha = glow_intensity * excess * 0.5;
            }
        }
    } else if (y > fragCoord.y) {
        // Normal bar drawing
        if (x > (float(bar) + 1.0) * bar_size - float(bar_spacing)) {
            color = bg_color;
        } else if (gradient_count == 0) {
            color = fg_color;
        } else {
            int color_index = int((gradient_count - 1) * fragCoord.y);
            float y_min = float(color_index) / float(gradient_count - 1);
            float y_max = float(color_index + 1) / float(gradient_count - 1);
            color = normalize_C(fragCoord.y, gradient_colors[color_index], gradient_colors[color_index + 1], y_min, y_max);
        }
    }

    fragColor = vec4(color, alpha);
}
