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
    kVATBindex_Pos = 0,

    // Fragment Shader Argument Table
    // Buffer index
    kFATBindex_GrayWeight = 0,
    // Texture index
    kFATTindex_Texture = 0

};

struct ShaderIO {
    vector_float4   position;
    vector_float2   texCoord;
};



#endif /* MetalShader_h */
