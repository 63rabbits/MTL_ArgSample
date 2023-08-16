//
//  ViewController.swift
//  MTL_ArgSample
//
//  Created by 63rabbits goodman on 2023/08/11.
//

import UIKit
import MetalKit



class ViewController: UIViewController, MTKViewDelegate {

    private let device = MTLCreateSystemDefaultDevice()!
    private var commandQueue: MTLCommandQueue!
    private var texture: MTLTexture!

    private var vertexBuffer: MTLBuffer!
    private var texCoordBuffer: MTLBuffer!
    private var renderPipeline: MTLRenderPipelineState!
    private let renderPassDescriptor = MTLRenderPassDescriptor()

    private var shaderIO: [ShaderIO] = [ShaderIO]()

    @IBOutlet private weak var mtkView: MTKView!

    override func viewDidLoad() {
        super.viewDidLoad()

        setupMetal()

        loadTexture()

        makePipeline(pixelFormat: texture.pixelFormat)

        mtkView.enableSetNeedsDisplay = true
        mtkView.setNeedsDisplay()
    }

    private func setupMetal() {
        commandQueue = device.makeCommandQueue()

        mtkView.device = device
        mtkView.delegate = self
    }

    private func makePipeline(pixelFormat: MTLPixelFormat) {
        guard let library = device.makeDefaultLibrary() else {fatalError()}
        let descriptor = MTLRenderPipelineDescriptor()
        descriptor.vertexFunction = library.makeFunction(name: "vertexShader")
        descriptor.fragmentFunction = library.makeFunction(name: "fragmentShader")
        descriptor.colorAttachments[0].pixelFormat = pixelFormat
        renderPipeline = try! device.makeRenderPipelineState(descriptor: descriptor)
    }

    private func loadTexture() {
        let textureLoader = MTKTextureLoader(device: device)
        texture = try! textureLoader.newTexture(
            name: "kerokero",
            scaleFactor: view.contentScaleFactor,
            bundle: nil)

        mtkView.colorPixelFormat = texture.pixelFormat
    }

    // MARK: - MTKViewDelegate

    func mtkView(_ view: MTKView, drawableSizeWillChange size: CGSize) {
        // nop
    }

    func draw(in view: MTKView) {
        guard let drawable = view.currentDrawable else {return}

        guard let commandBuffer = commandQueue.makeCommandBuffer() else {fatalError()}

        shaderIO = [
                        ShaderIO(position: vector_float4(-1, -1,  0,  1), texCoords: vector_float2(0, 1)),
                        ShaderIO(position: vector_float4( 1, -1,  0,  1), texCoords: vector_float2(1, 1)),
                        ShaderIO(position: vector_float4(-1,  1,  0,  1), texCoords: vector_float2(0, 0)),
                        ShaderIO(position: vector_float4( 1,  1,  0,  1), texCoords: vector_float2(1, 0))
                   ]

        renderPassDescriptor.colorAttachments[0].texture = drawable.texture

        guard let renderEncoder = commandBuffer.makeRenderCommandEncoder(descriptor: renderPassDescriptor) else {return}
        guard let renderPipeline = renderPipeline else {fatalError()}
        renderEncoder.setRenderPipelineState(renderPipeline)
        renderEncoder.setVertexBytes(self.shaderIO,
                                     length: MemoryLayout<ShaderIO>.stride * self.shaderIO.count,
                                     index: kVABindex_Pos)
        renderEncoder.setFragmentTexture(texture, index: kFATindex_Texture)
        var grayWeight = vector_float3(0.298912, 0.586611, 0.114478)
        renderEncoder.setFragmentBytes(&grayWeight,
                                       length: MemoryLayout<vector_float3>.stride,
                                       index: kFABindex_grayWeight)
        renderEncoder.drawPrimitives(type: .triangleStrip, vertexStart: 0, vertexCount: 4)

        renderEncoder.endEncoding()

        commandBuffer.present(drawable)

        commandBuffer.commit()

        commandBuffer.waitUntilCompleted()
    }
}

