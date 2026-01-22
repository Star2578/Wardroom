shader_type spatial;
render_mode unshaded, fog_disabled;

// Uniforms
uniform sampler2D screen_texture : hint_screen_texture;
uniform float grain_amount : hint_range(0.0, 1.0) = 0.05; // Adjust the amount of grain
uniform float grain_size : hint_range(0.1, 10.0) = 1.0; // Adjust the size of the grain

void vertex() {
	POSITION = vec4(VERTEX.xy, 1.0, 1.0);
}

void fragment() {
    // 1. Get the original color from the screen
    vec3 screen_color = texture(screen_texture, SCREEN_UV).rgb;
    
    // 2. Create a pseudo-random noise value
    // We use SCREEN_UV and TIME so the grain moves every frame
    float x = (SCREEN_UV.x + 4.0) * (SCREEN_UV.y + 4.0) * (TIME * 10.0);
    float grain = mod((mod(x, 13.0) + 1.0) * (mod(x, 123.0) + 1.0), 0.01) - 0.005;
    
    // 3. Scale the grain based on your uniforms
    grain *= grain_amount * 100.0;
    
    // 4. Apply the grain to the screen color
    // We add the grain value to the RGB channels
    vec3 final_color = screen_color + vec3(grain);
    
    ALBEDO = final_color;
}