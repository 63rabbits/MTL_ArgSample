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

    // Vertex Shader Argument Table

    // Buffer index
    kVABindex_Pos = 0,



    // Fragment Shader Argument Table

    // Buffer index
    kFABindex_grayWeight = 0,

    // Texture index
    kFATindex_Texture = 0

};

typedef struct
{
    vector_float4 position;
    vector_float2 texCoords;

} ShaderIO;



#endif /* MetalShader_h */
