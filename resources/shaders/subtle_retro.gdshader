shader_type canvas_item;
uniform bool enabled = false;
uniform float intensity : hint_range(0.0, 1.0) = 0.7;
uniform bool split_preview = false;

void fragment() {
    vec4 source = texture(TEXTURE, UV);
    vec3 banded = floor(source.rgb * 15.0 + 0.5) / 15.0;
    float scanline = mod(floor(UV.y * 360.0), 2.0) * 0.10;
    vec3 retro = mix(source.rgb, banded * (1.0 - scanline), intensity);
    bool affected = enabled && (!split_preview || UV.x >= 0.5);
    COLOR = vec4(affected ? retro : source.rgb, source.a);
}
