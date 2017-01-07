MDTOOL ?= /Applications/Xamarin\ Studio.app/Contents/MacOS/mdtool
OUTPUT_DIR ?= lib
COMPONENT_DIR ?= component

.PHONY: all clean package component pcl ios android

all: package component

clean:
	$(MDTOOL) build -c:Release -t:Clean Uniforms.Amplitude.sln
	rm -fv lib/Uniforms.*
	rm -fv component/*.xam

package: pcl
	cp -v Uniforms.Amplitude/bin/Release/*.dll* $(OUTPUT_DIR)
	mono $(MONO_OPTIONS) vendor/nuget/Nuget.exe pack -OutputDirectory $(OUTPUT_DIR)

component: ios android
	cp -v Uniforms.Amplitude.Droid/bin/Release/*.dll* $(OUTPUT_DIR)
	cp -v Uniforms.Amplitude.Native.Droid/bin/Release/*.dll* $(OUTPUT_DIR)
	cp -v Uniforms.Amplitude.iOS/bin/Release/*.dll* $(OUTPUT_DIR)
	cp -v Uniforms.Amplitude.Native.iOS/bin/Release/*.dll* $(OUTPUT_DIR)
	cd $(COMPONENT_DIR) && mono xamarin-component.exe package

pcl:
	$(MDTOOL) build -c:Release \
		-p:Uniforms.Amplitude \
		Uniforms.Amplitude.sln

ios:
	$(MDTOOL) build -c:Release \
		-p:Uniforms.Amplitude.Native.iOS \
		-p:Uniforms.Amplitude.iOS \
		Uniforms.Amplitude.sln

android:
	$(MDTOOL) build -c:Release \
		-p:Uniforms.Amplitude.Native.Droid \
		-p:Uniforms.Amplitude.Droid \
		Uniforms.Amplitude.sln