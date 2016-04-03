Pod::Spec.new do |spec|
  spec.name = "BidirectionalMap"
  spec.version = "1.0.4"
  spec.summary = "Bidirectional map implementation in swift"
  spec.homepage = "https://github.com/zefferus/BidirectionalMap"
  spec.license = { type: 'MIT', file: 'LICENSE' }
  spec.authors = { "Tom Wilkinson" => 'tbondwilkinson@gmail.com' }

  spec.platform = :ios, "9.3"
  spec.requires_arc = true
  spec.source = { git: "https://github.com/zefferus/BidirectionalMap.git", tag: "#{spec.version}", submodules: false }
  spec.source_files = "BidirectionalMap/**/*.{h,swift}"
end
