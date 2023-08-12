//
//  Kernel.metal
//  MTL_ArgSample
//
//  Created by 63rabbits goodman on 2023/08/11.
//

#include <metal_stdlib>
#include "MetalShader.h"
using namespace metal;

struct RasterizerData {
    float4 position [[ position ]];
    float2 texCoords;
};

vertex RasterizerData vertexShader(uint                 vid         [[ vertex_id ]],
                                   constant ShaderIO    *vertices   [[ buffer(kVABindex_Pos) ]]
                                  ) {
    RasterizerData out;
    out.position = vertices[vid].position;
    out.texCoords = vertices[vid].texCoords;
    return out;
}


fragment float4 fragmentShader(RasterizerData           in          [[ stage_in ]],
                               texture2d<float>         texture     [[ texture(kFATindex_Texture) ]],
                               constant vector_float3   *grayWeight [[ buffer(kFABindex_grayWeight) ]]
                              ) {
    constexpr sampler colorSampler;
    float4 color = texture.sample(colorSampler, in.texCoords);
    float  gray  = dot(color.rgb, *grayWeight);
    return float4(gray, gray, gray, 1.0);
}
