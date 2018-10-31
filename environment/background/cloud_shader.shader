shader_type canvas_item;


uniform float speed = 0.005;

void fragment()
{
	vec2 uv = fract( UV + vec2( -speed * TIME, 0.0 ) );
	COLOR = texture( TEXTURE, uv );
}