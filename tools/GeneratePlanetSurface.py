#!/usr/bin/env python2
import OpenImageIO as oiio
import sys

def AdaptSpecChannelCount( refereceSpec, nchannels ):
    return oiio.ImageSpec(refereceSpec.width,
                          refereceSpec.height,
                          nchannels,
                          refereceSpec.format)

def AdaptROIChannels( referenceROI, chbegin, chend ):
    return oiio.ROI(referenceROI.xbegin,
                    referenceROI.xend,
                    referenceROI.ybegin,
                    referenceROI.yend,
                    referenceROI.zbegin,
                    referenceROI.zend,
                    chbegin,
                    chend)

x = oiio.ImageBuf(sys.argv[1])
y = oiio.ImageBuf(sys.argv[2])
dudvRGB = oiio.ImageBuf(sys.argv[3])

surface = oiio.ImageBuf(AdaptSpecChannelCount(x.spec(), 4))
roi = oiio.get_roi(surface.spec())

dudvROI      = AdaptROIChannels(roi, 0, 2)
intensityROI = AdaptROIChannels(roi, 0, 1)

if not oiio.ImageBufAlgo.paste(surface, 0, 0, 0, 0, dudvRGB, dudvROI):
    raise RuntimeError(surface.geterror())
if not oiio.ImageBufAlgo.paste(surface, 0, 0, 0, 2, x, intensityROI):
    raise RuntimeError(surface.geterror())
if not oiio.ImageBufAlgo.paste(surface, 0, 0, 0, 3, y, intensityROI):
    raise RuntimeError(surface.geterror())

surface.specmod().attribute('oiio:UnassociatedAlpha', 1)
surface.write(sys.argv[4])
