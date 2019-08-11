# unity_shaders
=======
U3D Shaders Collection
======================
![](https://github.com/juanyig/unity_shaders/blob/master/readme_screenshots/title1.jpg)
# Description
These shaders are written completely by myself after my internship at Bilibili Company. The 3D model that is used for demonstration is also made on my own, and therefore cannot be used for any purpose. Most algorithms can be found in *Unity Shader 入门精要*. All references will be cited accordingly. 
# Content
## Basics
* Half-Lambert Lighting Model (Optimized)
* Blinn-Phong Lighting Model
* Rim Lighting
* Outline

## Toon Style Shading
* Toon Shader

## Hair Shading

## Post-Processing 
* Gaussian Blur
* Volumetric Light

### Basics
#### Half-Lambert Lighting Model (optimized)
The most basic way of calculating the color of a point P on a diffuse surface is by `Diffuse Color = Texture Color of P * Light Color * dot (L, N)` , where L is the direction from P to the light, and N is the normal direction of P. This model raises a problem. When the angle between such two vectors is greater than 90°, that is, `dot (L, N) < 0`, the value of color will be less than or equal to 0, therefore become entirely black. Half-Lambert lighting can be used to display more changes in color in areas that are not exposed to light directly by using `0.5 + dot (L, N) * 0.5 `, which is in the range of [0, 1] instead of [-1, 1]. Yet now, the color in shadow will still gradually descends to black. This is not desired in Japnese Toon shading style, so I made the shadow color self-selectable.<br>
*normal half-lambert* ![images](https://github.com/juanyig/unity_shaders/blob/master/readme_screenshots/1.png) <br>
*optimized half-lambert* ![images](https://github.com/juanyig/unity_shaders/blob/master/readme_screenshots/2.png)<br>
<br>

#### Blinn-Phong Lighting Model
This is implemented as a standard Blinn-Phong shader where `Specular Color =  Specular Color * pow(max(0.0, dot(N, H)), _Gloss) * Light Color` and `H = normalize(L + V)`(L is the direction from the point to light, and V is the view direction from the point on the surface to the camera). More detailed description on how Blinn-Phong Model works can be found on this [link](https://www.jianshu.com/p/6c45f0d7afd2).<br>
![images](https://github.com/juanyig/unity_shaders/blob/master/readme_screenshots/3.png)<br>
<br>

#### Rim Lighting
Rim lighting is also implemented with the standard method such that `rim = Rim Color * pow(1.0 - dot(N, V), RimPower)`. N is the normal direction of P, and V is the view direction from the point the surface to the camera. We want to see rim lighting on the edges of the object (i.e, the angle between N and V is closer to 90°), and no rim lighting on the front (the angle between N and V is less than 90°), and that is where `1 - dot(N, V)` comes from. More detailed description on how rim lighting works can be found on this [link](https://blog.csdn.net/puppet_master/article/details/53548134).<br>
*without rim lighting* ![images](https://github.com/juanyig/unity_shaders/blob/master/readme_screenshots/4.png)<br>
*with rim lighting* ![images](https://github.com/juanyig/unity_shaders/blob/master/readme_screenshots/5.png)<br>
![images](https://github.com/juanyig/unity_shaders/blob/master/readme_screenshots/6.png)<br>
<br>

#### Outline
Drawing Outline around the selected object used the traditional method of extruding the back face along each vertex's normal direction on the first pass, cull the front, and render the object on the second pass. This implementation will not be effective when the vertex has more than one normal, such as a standard cube. A quick fix is to interpolate the direction of extrusion by both the normal direction and the vertex direction.(TO DO) More detailed descirption on how outline shader works can be found on this [link](https://blog.csdn.net/puppet_master/article/details/54000951).<br>
![images](https://github.com/juanyig/unity_shaders/blob/master/readme_screenshots/7.png)<br>
![images](https://github.com/juanyig/unity_shaders/blob/master/readme_screenshots/8.png)<br>
![images](https://github.com/juanyig/unity_shaders/blob/master/readme_screenshots/9.png)<br>
<br>

### Toon Style Shading
#### Toon Shader
Toon shader is implemented as a simple 2-shade toon shader plus 1 specular color which all of the colors are user-selectable. More shades can be achieved with a ramp texture.<br>
*2-shade style*![images](https://github.com/juanyig/unity_shaders/blob/master/readme_screenshots/10.png)<br>
![images](https://github.com/juanyig/unity_shaders/blob/master/readme_screenshots/12.png)<br>
*4 shades with ramp texture*![images](https://github.com/juanyig/unity_shaders/blob/master/readme_screenshots/11.png)<br>
![images](https://github.com/juanyig/unity_shaders/blob/master/readme_screenshots/13.png)<br>
<br>

### Hair Shading
In order to mimic realistic hair highlight, I implemented Kajiya-Kay's hair shading model. The most important concept Kajiya-Kay introduces is that specularity is influnced by tangent instead of normal in the lighting equation, that is, `Specular Color = dirAtten * pow(sinTH, HighlightPower) * LightColor * HighlightColor` and `sinTH = sqrt(1 - pow(dot(N, H),2))`. Then we can use a noise texture to intervene specularity on each tangent direction, thereby achieving the realistic zigzag effect. This implementation also brought the concept of 2 highlight scattering from Marschner's hair model. Colors of both highlights can be chosen, and the shift between the two can be user-defined as well. Detailed algorithm explanation can be found on: [link1](http://web.engr.oregonstate.edu/~mjb/cs519/Projects/Papers/HairRendering.pdf) [link2](https://www.zhihu.com/question/36946353)<br>
![images](https://github.com/juanyig/unity_shaders/blob/master/readme_screenshots/14.png)<br>
![images](https://github.com/juanyig/unity_shaders/blob/master/readme_screenshots/15.png)<br>
![images](https://github.com/juanyig/unity_shaders/blob/master/readme_screenshots/16.png)<br>
<br>
### Post-Processing
#### Gaussian Blur
Gaussian blur is implemented using the standard method where each pixel's color is determined by its own color and its surrounding pixels' color, and is weighted according to standard normal distribution. (TODO) Algroithm can be optimized.<br>
![images](https://github.com/juanyig/unity_shaders/blob/master/readme_screenshots/21.png)<br>
*without blur*![images](https://github.com/juanyig/unity_shaders/blob/master/readme_screenshots/17.png)<br>
*with blur*![images](https://github.com/juanyig/unity_shaders/blob/master/readme_screenshots/18.png)<br>
<br>

#### Volumetric Light
(TODO)
