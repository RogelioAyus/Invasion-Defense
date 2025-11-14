shader_type canvas_item;
render_mode blend_mix;

uniform float speedC = 0;
uniform float strength = 0;
uniform float differenciate = 0;

void vertex()
{
	VERTEX.x += sin(TIME * speedC + VERTEX.x + (differenciate*2.0)) * strength;
	VERTEX.y += cos(TIME * speedC + VERTEX.y + (differenciate/1.5)) * strength;
	
}
