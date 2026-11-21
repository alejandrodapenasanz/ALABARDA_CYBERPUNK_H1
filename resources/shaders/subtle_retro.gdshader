shader_type canvas_item;
uniform bool enabled = false;
uniform float intensity : hint_range(0.0, 1.0) = 0.25;

void fragment() {
    vec4 source = texture(TEXTURE, UV);
    vec3 banded = floor(source.rgb * 31.0 + 0.5) / 31.0;
    float scanline = mod(floor(FRAGCOORD.y), 2.0) * 0.018;
    COLOR = vec4(enabled ? mix(source.rgb, banded - scanline, intensity) : source.rgb, source.a);
}
