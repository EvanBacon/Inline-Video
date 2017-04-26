

precision highp float;

uniform sampler2D video;
uniform vec2 resolution;
uniform vec2 videoResolution;
uniform float currentTime;
uniform int mode;
varying vec2 vUv;

#pragma glslify: luma = require('glsl-luma')
#pragma glslify: crosshatch = require('glsl-crosshatch-filter')



uniform sampler2D texture;

uniform vec2 sketchSize;
uniform vec2 offset;

uniform float pixelSize;

mat4 rgba2sepia =
mat4
(
0.393, 0.349, 0.272, 0,
0.769, 0.686, 0.534, 0,
0.189, 0.168, 0.131, 0,
0,     0,     0,     1
);

vec3 hsv2rgb(vec3 c)
{
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}
void main() {
   gl_FragColor = texture2D(video, vUv);

   if (mode == 0) {

   vec2 coord = vUv;
   coord.x *= resolution.x / resolution.y;


   //gl_FragColor = texture2D(video, coord);
   gl_FragColor.rgb = mix(gl_FragColor.rgb, hsv2rgb(vec3(0.3, 0.7, 0.9)), 0.5);

   } else {
     vec2 coord = vUv;
     coord.x *= resolution.x / resolution.y;
     vec3 effect = crosshatch(gl_FragColor.rgb);
     gl_FragColor.rgb = mix(gl_FragColor.rgb,  effect, 0.5);
   }
}
