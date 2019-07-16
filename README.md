U3D Shaders Collection
======================
pics
# Description
desc
# Content
## Basics
* Half-Lambert Lighting Model (Optimized)
* Blinn-Phong Lighting Model
* Rim Lighting
* Outline

## Toon Style Shading
* Toon Shader
* Anime Hair Shading

## Post-Processing 
* Gaussian Blur
* Bloom
* Volumetric Light

### Basics
#### Half-Lambert Lighting Model (optimized)
The most basic way of calculating the color of a point P on a diffuse surface is by `Diffuse Color = Texture Color of P * Light Color * dot (L, N)` , where L is the direction from P to the light, and N is the normal direction of P. This model raises a proble. When the angle between such two vectors is greater than 90°, that is, `dot (L, N) < 0`, the value of color will be less than or equal to 0, therefore become entirely black. Half-Lambert lighting can be used to display more changes in color in areas that are not exposed to light directly by using `0.5 + dot (L, N) * 0.5 `, which is in the range of [0, 1] instead of [-1, 1]. Yet now, the color in shadow will still gradually descends to black. This is not desired in Japnese Toon shading style, so I made a self-selectable shadow color.<br>
<br>

#### Blinn-Phong Lighting Model
This is implemented as a standard Blinn-Phong shader where `Specular Color =  Specular Color * pow(max(0.0, dot(N, H)), _Gloss) * Light Color` where `H = normalize(L + V)`(L is the direction from the point to light, and V is the view direction from the point on the surface to the camera). More detailed description on how Blinn-Phong Model works can be found on this [link](https://www.jianshu.com/p/6c45f0d7afd2).<br>
<br>

#### Rim Lighting
Rim lighting is also implemented with the standard method that `rim = Rim Color * pow(1.0 - dot(N, V), RimPower)`. N is the normal direction of P, and V is the view direction from the point the surface to the camera. We want to see rim lighting on the edges of the object (the angle between N and V is closer to 90°), and no rim lighting on the front (the angle between N and V is less than 90°), and that is where `1 - dot(N, V)` comes from. More detailed description on how rim lighting works can be found on this [link](https://blog.csdn.net/puppet_master/article/details/53548134).<br>
<br>

#### Outline
Drawing Outline around the selected object used the traditional method of extruding the back face along each vertex's normal direction, cull the front, and render the object on the second pass. This implementation will not be effective when the angle between adjacent faces is less than or equall to 90°, such as cube. A quick fix is to interpolate the direction of extrusion by both the normal direction and the vertex direction.(TO DO) More detailed descirption on how outline shader works can be found on this [link](https://blog.csdn.net/puppet_master/article/details/54000951).<br>
<br>

### Toon Style Shading
#### Toon Shader
This is implemented as a simple 2-shade toon shader plus 1 specular color which all of them are self-selectable.

#### Anime Hair Shading
In order to mimic anime style hair highlight, I used Kajiya-Kay's hair shading model then clamp it to toon shading style. The most important concept Kajiya-Kay introduces is that specularity is influnced by tangent instead of normal in the lighting equation. Reference articles: [link1](http://web.engr.oregonstate.edu/~mjb/cs519/Projects/Papers/HairRendering.pdf) [link2](https://www.zhihu.com/question/36946353) [link3](https://blog.csdn.net/sdqq1234/article/details/61437045)<br>
