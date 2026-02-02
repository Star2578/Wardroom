shader_type sky;

uniform vec3 bg_color : source_color = vec3(0.0, 0.02, 0.05);
uniform vec3 star_color : source_color = vec3(1.0, 1.0, 1.0);
uniform float star_density : hint_range(0.0, 1000.0) = 500.0;
uniform float star_threshold : hint_range(0.0, 1.0) = 0.95;
uniform float pixelation : hint_range(1.0, 2048.0) = 512.0;

// Simple hash function for randomness
float hash(vec2 p) {
	return fract(sin(dot(p, vec2(12.9898, 78.233))) * 43758.5453);
}

void sky() {
	// 1. Get the direction and convert to 2D coordinates
	vec2 uv = EYEDIR.xz / (abs(EYEDIR.y) + 1.0);
	
	// 2. Pixelate the UV coordinates
	// This snaps the stars to a grid to match a low-poly style
	vec2 pixel_uv = floor(uv * pixelation) / pixelation;
	
	// 3. Generate "stars" based on the pixelated grid
	float star_value = hash(pixel_uv * star_density);
	
	// 4. Filter the noise so only the brightest "pixels" become stars
	float star_mask = step(star_threshold, star_value);
	
	// 5. Apply colors
	// We use the original EYEDIR.y to add a slight gradient to the horizon
	float horizon_glow = smoothstep(-0.2, 0.5, EYEDIR.y);
	vec3 final_color = mix(bg_color * 0.5, bg_color, horizon_glow);
	
	final_color += star_mask * star_color;

	COLOR = final_color;
}