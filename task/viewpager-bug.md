# Task

Fix the following bug when trying to swipe between screens.

# Stacktrace

```
===================================================================================
I/flutter (26073): [debug] [simple-currency] [CrashlyticsUtils] Recording error to Crashlytics: Exception: 'package:flutter/src/rendering/sliver_multi_box_adaptor.dart': Failed assertion: line 277 pos 16: 'child == null || indexOf(child) > index': is not true.
I/flutter (26073): ----------------FIREBASE CRASHLYTICS----------------
I/flutter (26073): Exception: 'package:flutter/src/rendering/sliver_multi_box_adaptor.dart': Failed assertion: line 277 pos 16: 'child == null || indexOf(child) > index': is not true.
I/flutter (26073): #0      _AssertionError._doThrowNew (dart:core-patch/errors_patch.dart:67:4)
I/flutter (26073): #1      _AssertionError._throwNew (dart:core-patch/errors_patch.dart:49:5)
I/flutter (26073): #2      RenderSliverMultiBoxAdaptor._debugVerifyChildOrder (package:flutter/src/rendering/sliver_multi_box_adaptor.dart:277:16)
I/flutter (26073): #3      RenderSliverMultiBoxAdaptor.insert (package:flutter/src/rendering/sliver_multi_box_adaptor.dart:288:12)
I/flutter (26073): #4      SliverMultiBoxAdaptorElement.insertRenderObjectChild (package:flutter/src/widgets/sliver.dart:1171:18)
I/flutter (26073): #5      RenderObjectElement.attachRenderObject (package:flutter/src/widgets/framework.dart:6844:35)
I/flutter (26073): #6      RenderObjectElement.mount (package:flutter/src/widgets/framework.dart:6706:5)
I/flutter (26073): #7      SingleChildRenderObjectElement.mount (package:flutter/src/widgets/framework.dart:7017:11)
I/flutter (26073): #8      Element.inflateWidget (package:flutter/src/widgets/framework.dart:4548:16)
I/flutter (26073): #9      Element.updateChild (package:flutter/src/widgets/framework.dart:4004:18)
I/flutter (26073): #10     ComponentElement.performRebuild (package:flutter/src/widgets/fr
I/flutter (26073): ----------------------------------------------------
I/flutter (26073): [debug] [simple-currency] [utils/firebase] [Firebase] Flutter error caught: 'package:flutter/src/rendering/sliver_multi_box_adaptor.dart': Failed assertion: line 277 pos 16: 'child == null || indexOf(child) > index': is not true.

======== Exception caught by widgets library =======================================================
The following assertion was thrown building ErrorScreen(dependencies: [_LocalizationsScope-[GlobalKey#472b4]], state: _ErrorScreenState#f325a):
'package:flutter/src/rendering/sliver_multi_box_adaptor.dart': Failed assertion: line 277 pos 16: 'child == null || indexOf(child) > index': is not true.


Either the assertion indicates an error in the framework itself, or we should provide substantially more information in this error message to help you determine and fix the underlying cause.
In either case, please report this assertion by filing a bug on GitHub:
  https://github.com/flutter/flutter/issues/new?template=02_bug.yml

The relevant error-causing widget was: 
  ErrorScreen ErrorScreen:file:///home/wes/Android/Projects/cnvrt/lib/app.dart:37:16
When the exception was thrown, this was the stack: 
#2      RenderSliverMultiBoxAdaptor._debugVerifyChildOrder (package:flutter/src/rendering/sliver_multi_box_adaptor.dart:277:16)
#3      RenderSliverMultiBoxAdaptor.insert (package:flutter/src/rendering/sliver_multi_box_adaptor.dart:288:12)
#4      SliverMultiBoxAdaptorElement.insertRenderObjectChild (package:flutter/src/widgets/sliver.dart:1171:18)
#5      RenderObjectElement.attachRenderObject (package:flutter/src/widgets/framework.dart:6844:35)
#6      RenderObjectElement.mount (package:flutter/src/widgets/framework.dart:6706:5)
#7      SingleChildRenderObjectElement.mount (package:flutter/src/widgets/framework.dart:7017:11)
...     Normal element mounting (2667 frames)
#2674   Element.inflateWidget (package:flutter/src/widgets/framework.dart:4548:16)
#2675   Element.updateChild (package:flutter/src/widgets/framework.dart:4004:18)
#2676   SliverMultiBoxAdaptorElement.updateChild (package:flutter/src/widgets/sliver.dart:1001:37)
#2677   SliverMultiBoxAdaptorElement.createChild.<anonymous closure> (package:flutter/src/widgets/sliver.dart:985:20)
#2678   BuildOwner.buildScope (package:flutter/src/widgets/framework.dart:3046:19)
#2679   SliverMultiBoxAdaptorElement.createChild (package:flutter/src/widgets/sliver.dart:975:12)
#2680   RenderSliverMultiBoxAdaptor._createOrObtainChild.<anonymous closure> (package:flutter/src/rendering/sliver_multi_box_adaptor.dart:372:23)
#2681   RenderObject.invokeLayoutCallback.<anonymous closure> (package:flutter/src/rendering/object.dart:2881:17)
#2682   PipelineOwner._enableMutationsToDirtySubtrees (package:flutter/src/rendering/object.dart:1206:15)
#2683   RenderObject.invokeLayoutCallback (package:flutter/src/rendering/object.dart:2880:14)
#2684   RenderSliverMultiBoxAdaptor._createOrObtainChild (package:flutter/src/rendering/sliver_multi_box_adaptor.dart:360:5)
#2685   RenderSliverMultiBoxAdaptor.insertAndLayoutChild (package:flutter/src/rendering/sliver_multi_box_adaptor.dart:523:5)
#2686   RenderSliverFixedExtentBoxAdaptor.performLayout (package:flutter/src/rendering/sliver_fixed_extent_list.dart:369:17)
#2687   RenderObject.layout (package:flutter/src/rendering/object.dart:2762:7)
#2688   RenderSliverEdgeInsetsPadding.performLayout (package:flutter/src/rendering/sliver_padding.dart:133:12)
#2689   _RenderSliverFractionalPadding.performLayout (package:flutter/src/widgets/sliver_fill.dart:162:11)
#2690   RenderObject.layout (package:flutter/src/rendering/object.dart:2762:7)
#2691   RenderViewportBase.layoutChildSequence (package:flutter/src/rendering/viewport.dart:673:13)
#2692   RenderViewport._attemptLayout (package:flutter/src/rendering/viewport.dart:1684:12)
#2693   RenderViewport.performLayout (package:flutter/src/rendering/viewport.dart:1575:20)
#2694   RenderObject._layoutWithoutResize (package:flutter/src/rendering/object.dart:2610:7)
#2695   PipelineOwner.flushLayout (package:flutter/src/rendering/object.dart:1157:18)
#2696   PipelineOwner.flushLayout (package:flutter/src/rendering/object.dart:1170:15)
#2697   RendererBinding.drawFrame (package:flutter/src/rendering/binding.dart:629:23)
#2698   WidgetsBinding.drawFrame (package:flutter/src/widgets/binding.dart:1261:13)
#2699   RendererBinding._handlePersistentFrameCallback (package:flutter/src/rendering/binding.dart:495:5)
#2700   SchedulerBinding._invokeFrameCallback (package:flutter/src/scheduler/binding.dart:1434:15)
#2701   SchedulerBinding.handleDrawFrame (package:flutter/src/scheduler/binding.dart:1347:9)
#2702   SchedulerBinding._handleDrawFrame (package:flutter/src/scheduler/binding.dart:1200:5)
#2703   _invoke (dart:ui/hooks.dart:330:13)
#2704   PlatformDispatcher._drawFrame (dart:ui/platform_dispatcher.dart:444:5)
#2705   _drawFrame (dart:ui/hooks.dart:302:31)
(elided 2 frames from class _AssertionError)
====================================================================================================

======== Exception caught by widgets library =======================================================
The following assertion was thrown building ErrorScreen(dependencies: [_LocalizationsScope-[GlobalKey#472b4]], state: _ErrorScreenState#f325a):
'package:flutter/src/rendering/sliver_multi_box_adaptor.dart': Failed assertion: line 277 pos 16: 'child == null || indexOf(child) > index': is not true.


Either the assertion indicates an error in the framework itself, or we should provide substantially more information in this error message to help you determine and fix the underlying cause.
In either case, please report this assertion by filing a bug on GitHub:
  https://github.com/flutter/flutter/issues/new?template=02_bug.yml

The relevant error-causing widget was: 
  ErrorScreen ErrorScreen:file:///home/wes/Android/Projects/cnvrt/lib/app.dart:37:16
When the exception was thrown, this was the stack: 
#2      RenderSliverMultiBoxAdaptor._debugVerifyChildOrder (package:flutter/src/rendering/sliver_multi_box_adaptor.dart:277:16)
#3      RenderSliverMultiBoxAdaptor.insert (package:flutter/src/rendering/sliver_multi_box_adaptor.dart:288:12)
#4      SliverMultiBoxAdaptorElement.insertRenderObjectChild (package:flutter/src/widgets/sliver.dart:1171:18)
#5      RenderObjectElement.attachRenderObject (package:flutter/src/widgets/framework.dart:6844:35)
#6      RenderObjectElement.mount (package:flutter/src/widgets/framework.dart:6706:5)
#7      SingleChildRenderObjectElement.mount (package:flutter/src/widgets/framework.dart:7017:11)
...     Normal element mounting (2667 frames)
#2674   Element.inflateWidget (package:flutter/src/widgets/framework.dart:4548:16)
#2675   Element.updateChild (package:flutter/src/widgets/framework.dart:4004:18)
#2676   SliverMultiBoxAdaptorElement.updateChild (package:flutter/src/widgets/sliver.dart:1001:37)
#2677   SliverMultiBoxAdaptorElement.createChild.<anonymous closure> (package:flutter/src/widgets/sliver.dart:985:20)
#2678   BuildOwner.buildScope (package:flutter/src/widgets/framework.dart:3046:19)
#2679   SliverMultiBoxAdaptorElement.createChild (package:flutter/src/widgets/sliver.dart:975:12)
#2680   RenderSliverMultiBoxAdaptor._createOrObtainChild.<anonymous closure> (package:flutter/src/rendering/sliver_multi_box_adaptor.dart:372:23)
#2681   RenderObject.invokeLayoutCallback.<anonymous closure> (package:flutter/src/rendering/object.dart:2881:17)
#2682   PipelineOwner._enableMutationsToDirtySubtrees (package:flutter/src/rendering/object.dart:1206:15)
#2683   RenderObject.invokeLayoutCallback (package:flutter/src/rendering/object.dart:2880:14)
#2684   RenderSliverMultiBoxAdaptor._createOrObtainChild (package:flutter/src/rendering/sliver_multi_box_adaptor.dart:360:5)
#2685   RenderSliverMultiBoxAdaptor.insertAndLayoutChild (package:flutter/src/rendering/sliver_multi_box_adaptor.dart:523:5)
#2686   RenderSliverFixedExtentBoxAdaptor.performLayout (package:flutter/src/rendering/sliver_fixed_extent_list.dart:369:17)
#2687   RenderObject.layout (package:flutter/src/rendering/object.dart:2762:7)
#2688   RenderSliverEdgeInsetsPadding.performLayout (package:flutter/src/rendering/sliver_padding.dart:133:12)
#2689   _RenderSliverFractionalPadding.performLayout (package:flutter/src/widgets/sliver_fill.dart:162:11)
#2690   RenderObject.layout (package:flutter/src/rendering/object.dart:2762:7)
#2691   RenderViewportBase.layoutChildSequence (package:flutter/src/rendering/viewport.dart:673:13)
#2692   RenderViewport._attemptLayout (package:flutter/src/rendering/viewport.dart:1684:12)
#2693   RenderViewport.performLayout (package:flutter/src/rendering/viewport.dart:1575:20)
#2694   RenderObject._layoutWithoutResize (package:flutter/src/rendering/object.dart:2610:7)
#2695   PipelineOwner.flushLayout (package:flutter/src/rendering/object.dart:1157:18)
#2696   PipelineOwner.flushLayout (package:flutter/src/rendering/object.dart:1170:15)
#2697   RendererBinding.drawFrame (package:flutter/src/rendering/binding.dart:629:23)
#2698   WidgetsBinding.drawFrame (package:flutter/src/widgets/binding.dart:1261:13)
#2699   RendererBinding._handlePersistentFrameCallback (package:flutter/src/rendering/binding.dart:495:5)
#2700   SchedulerBinding._invokeFrameCallback (package:flutter/src/scheduler/binding.dart:1434:15)
#2701   SchedulerBinding.handleDrawFrame (package:flutter/src/scheduler/binding.dart:1347:9)
#2702   SchedulerBinding._handleDrawFrame (package:flutter/src/scheduler/binding.dart:1200:5)
#2703   _invoke (dart:ui/hooks.dart:330:13)
#2704   PlatformDispatcher._drawFrame (dart:ui/platform_dispatcher.dart:444:5)
#2705   _drawFrame (dart:ui/hooks.dart:302:31)
(elided 2 frames from class _AssertionError)
====================================================================================================
```
