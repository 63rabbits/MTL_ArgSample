//
//  MetalShader.h
//  MTL_ArgSample
//
//  Created by 63rabbits goodman on 2023/08/11.
//

#ifndef MetalShader_h
#define MetalShader_h



#include <simd/simd.h>

enum {
    kBuf_Pos = 0,
    kBuf_grayWeight = 1,

    kTex_Texture = 0,
};

typedef struct
{
    vector_float4 position;
    vector_float2 texCoords;

} ShaderIO;



#endif /* MetalShader_h */
