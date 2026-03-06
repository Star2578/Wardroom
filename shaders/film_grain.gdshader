shader_type canvas_item;

// Uniforms
uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;
uniform float grain_amount : hint_range(0.0, 1.0) = 0.05; 
uniform float grain_size : hint_range(0.1, 10.0) = 1.0; 

void fragment() {
    // 1. Get the original color from the screen behind the ColorRect
    // In canvas_item, we use SCREEN_UV to sample the screen_texture
    vec3 screen_color = texture(screen_texture, SCREEN_UV).rgb;
    
    // 2. Your original pseudo-random noise logic
    // We adjust by grain_size here
    vec2 uv = SCREEN_UV * grain_size;
    float x = (uv.x + 4.0) * (uv.y + 4.0) * (TIME * 10.0);
    float grain = mod((mod(x, 13.0) + 1.0) * (mod(x, 123.0) + 1.0), 0.01) - 0.005;
    
    // 3. Scale the grain based on your uniforms
    grain *= grain_amount * 100.0;
    
    // 4. Apply the grain to the screen color
    vec3 final_color = screen_color + vec3(grain);
    
    // In 2D shaders, we output to COLOR instead of ALBEDO
    COLOR = vec4(final_color, 1.0);
}