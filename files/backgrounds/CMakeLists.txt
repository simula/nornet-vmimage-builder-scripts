# --------------------------------------------------------------------------
#
#           #####          #     #   ###   #
#          #     #  #    # ##    #    #    #          ##    #####
#          #        #    # # #   #    #    #         #  #   #    #
#           #####   #    # #  #  #    #    #        #    #  #####
#                #  #    # #   # #    #    #        ######  #    #
#          #     #  #    # #    ##    #    #        #    #  #    #
#           #####    ####  #     #   ###   #######  #    #  #####
#
# --------------------------------------------------------------------------
#
# SuNILab Desktop Background Script
# Copyright (C) 2017-2025 by Thomas Dreibholz
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY# without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#
# Contact: thomas.dreibholz@gmail.com


#############################################################################
# INITIALISE
#############################################################################

CMAKE_MINIMUM_REQUIRED(VERSION 3.5...3.31)
PROJECT(undefined C)   # to be set in Settings.input
INCLUDE(Settings.input)


#############################################################################
# INSTALLATION_DIRECTORIES
#############################################################################

# See: https://cmake.org/cmake/help/v3.0/module/GNUInstallDirs.html
INCLUDE(GNUInstallDirs)


#############################################################################
# OPTIONS
#############################################################################

OPTION(FLAT_DIRECTORY_STRUCTURE "Use flat directory structure" ${TDD_FLAT_DIRECTORY_STRUCTURE})

OPTION(INSTALL_ORIGINALS "Install original images as well" ${TDD_INSTALL_ORIGINALS})

OPTION(INSERT_HOSTNAME "Insert hostnames into images" ${TDD_INSERT_HOSTNAME})

OPTION(BUILD_MIRRORED "Build mirrored" ${TDD_BUILD_MIRRORED})

OPTION(BUILD_BOOTSPLASH "Build bootsplash JPEG" ${TDD_BUILD_BOOTSPLASH})
IF(NOT TDD_BOOTSPLASH_RESOLUTIONS)
   # Legacy option: use TDD_BOOTSPLASH_RESOLUTION (one resolution only)
   SET(TDD_BOOTSPLASH_RESOLUTIONS ${TDD_BOOTSPLASH_RESOLUTION})
ENDIF()
IF(BUILD_BOOTSPLASH)
   LIST(APPEND TDD_RESOLUTIONS "${TDD_BOOTSPLASH_RESOLUTIONS}")
   LIST(APPEND TDD_VARIANTS    "${TDD_BOOTSPLASH_VARIANT}")
ENDIF()

OPTION(PRINT_A4 "Build A4 PDF print version" ${TDD_PRINT_A4})
OPTION(PRINT_A3 "Build A3 PDF print version" ${TDD_PRINT_A3})
IF(PRINT_A4 OR PRINT_A3)
   LIST(APPEND TDD_RESOLUTIONS "2970x2100")
   LIST(APPEND TDD_VARIANTS    "${TDD_PRINT_VARIANT}")
ENDIF()


#############################################################################
# REQUIREMENTS
#############################################################################

INCLUDE(FindUnixCommands)

# ------ Required prgorams --------------------------------------------------
FIND_PROGRAM(AWK awk PATHS /bin /usr/bin /usr/local/bin)
IF(NOT AWK)
   MESSAGE(FATAL_ERROR
           " Cannot find AWK! Try:\n"
           " * Ubuntu/Debian: sudo apt install -y awk\n"
           " * Fedora:        sudo dnf install -y awk\n"
           " * FreeBSD:       (should always be there!")
ENDIF()

FIND_PROGRAM(GM gm PATHS /bin /usr/bin /usr/local/bin)
IF(NOT GM)
   MESSAGE(FATAL_ERROR
           " Cannot find GraphicsMagick! Try:\n"
           " * Ubuntu/Debian: sudo apt install -y graphicsmagick\n"
           " * Fedora:        sudo dnf install -y GraphicsMagick\n"
           " * FreeBSD:       sudo pkg install -y GraphicsMagick")
ENDIF()

FIND_PROGRAM(GIMP gimp PATHS /bin /usr/bin /usr/local/bin)
IF(NOT GIMP)
   MESSAGE(FATAL_ERROR
           " Cannot find Gimp! Try:\n"
           " * Ubuntu/Debian: sudo apt install -y gimp\n"
           " * Fedora:        sudo dnf install -y gimp\n"
           " * FreeBSD:       sudo pkg install -y gimp")
ENDIF()

# NOTE: exiftool fails to handle GIMP-generated JPEG files under
# Debian Stretch and Ubuntu Trusty. Errors are just ignored in this case
# (i.e. the EXIF information will not be updated).
FIND_PROGRAM(EXIFTOOL exiftool PATHS /bin /usr/bin /usr/local/bin)
IF(NOT EXIFTOOL)
   MESSAGE(FATAL_ERROR
           " Cannot find ExifTool! Try:\n"
           " * Ubuntu/Debian: sudo apt install -y libimage-exiftool-perl\n"
           " * Fedora:        sudo dnf install -y perl-Image-ExifTool\n"
           " * FreeBSD:       sudo pkg install -y p5-Image-ExifTool")
ENDIF()

# ------ Required scripts ---------------------------------------------------
FIND_PROGRAM(TEST_GIMP ${TDD_TEST_GIMP})
IF(NOT TEST_GIMP)
   MESSAGE(FATAL_ERROR "Test-Gimp (${TDD_TEST_GIMP}) not found!")
ENDIF()

FIND_PROGRAM(MAKE_CROPPED ${TDD_MAKE_CROPPED})
IF(NOT MAKE_CROPPED)
   MESSAGE(FATAL_ERROR "Resize-with-Cropping (${TDD_MAKE_CROPPED}) not found!")
ENDIF()

FIND_PROGRAM(MAKE_CAPTION ${TDD_MAKE_CAPTION})
IF(NOT MAKE_CAPTION)
   MESSAGE(FATAL_ERROR "Make-Caption (${TDD_MAKE_CAPTION}) not found!")
ENDIF()

FIND_PROGRAM(MAKE_GLOSSYTEXT ${TDD_MAKE_GLOSSYTEXT})
IF(NOT MAKE_GLOSSYTEXT)
   MESSAGE(FATAL_ERROR "Make-GlossyText (${TDD_MAKE_GLOSSYTEXT}) not found!")
ENDIF()

FIND_PROGRAM(MAKE_BUMPMAP ${TDD_MAKE_BUMPMAP})
IF(NOT MAKE_BUMPMAP)
   MESSAGE(FATAL_ERROR "Make-BumpMap (${TDD_MAKE_BUMPMAP}) not found!")
ENDIF()

FIND_PROGRAM(MAKE_OILPAINTING ${TDD_MAKE_OILPAINTING})
IF(NOT MAKE_OILPAINTING)
   MESSAGE(FATAL_ERROR "Make-OilPainting (${TDD_MAKE_OILPAINTING}) not found!")
ENDIF()

FIND_PROGRAM(MAKE_MOSAIC ${TDD_MAKE_MOSAIC})
IF(NOT MAKE_MOSAIC)
   MESSAGE(FATAL_ERROR "Make-Mosaic (${TDD_MAKE_MOSAIC}) not found!")
ENDIF()

FIND_PROGRAM(MAKE_CLOTH ${TDD_MAKE_CLOTH})
IF(NOT MAKE_CLOTH)
   MESSAGE(FATAL_ERROR "Make-Cloth (${TDD_MAKE_CLOTH}) not found!")
ENDIF()

FIND_PROGRAM(MAKE_OLDPHOTO ${TDD_MAKE_OLDPHOTO})
IF(NOT MAKE_OLDPHOTO)
   MESSAGE(FATAL_ERROR "Make-OldPhoto (${TDD_MAKE_OLDPHOTO}) not found!")
ENDIF()

# ------ Customised background scripts --------------------------------------
FIND_PROGRAM(BUILD_CAPTION ${TDD_BUILD_CAPTION})
IF(NOT BUILD_CAPTION)
   MESSAGE(FATAL_ERROR "Caption script (${TDD_BUILD_CAPTION}) not found!")
ENDIF()

FIND_PROGRAM(BUILD_OVERLAY ${TDD_BUILD_OVERLAY})
IF(NOT BUILD_OVERLAY)
   MESSAGE(FATAL_ERROR "Caption script (${TDD_BUILD_OVERLAY}) not found!")
ENDIF()


#############################################################################
# REQUIREMENTS
#############################################################################

IF(TDD_ADD_DIST_TARGET)
   SET(CPACK_SOURCE_GENERATOR "TGZ")
   SET(CPACK_SOURCE_PACKAGE_FILE_NAME
      "${CMAKE_PROJECT_NAME}-${BUILD_MAJOR}.${BUILD_MINOR}.${BUILD_PATCH}")
   SET(CPACK_SOURCE_IGNORE_FILES
      "${PROJECT_SOURCE_DIR}/${CMAKE_PROJECT_NAME}-*;${PROJECT_SOURCE_DIR}/${CMAKE_PROJECT_NAME}_*;/build/;/.git/;/.gimp/;/config.log;/CMakeFiles/;CMakeCache.txt$;.cmake$;.tar.gz$;/_CPack_Packages;/Makefile$;~$;/build-deb;/clean-deb;/filter-empty-entries;/make-symbols;/make-ppa;/make-deb;/debian.conf;/make-rpm;/rpm.conf;${CPACK_SOURCE_IGNORE_FILES};/Output/")

   INCLUDE(CPack)
   ADD_CUSTOM_TARGET(dist COMMAND +${CMAKE_MAKE_PROGRAM} clean package_source)
ENDIF()


#############################################################################
# BUILD TARGETS
#############################################################################

# NOTE: The following build rules use custom commands. They need additional
#       targets as well, to correctly run parallel builds! For details, see:
# https://samthursfield.wordpress.com/2015/11/21/cmake-dependencies-between-targets-and-files-and-custom-commands/

LIST(REMOVE_DUPLICATES TDD_RESOLUTIONS)
LIST(SORT TDD_RESOLUTIONS)
LIST(REMOVE_DUPLICATES TDD_IMAGE_FILES)
LIST(SORT TDD_IMAGE_FILES)
LIST(REMOVE_DUPLICATES TDD_TEXT_FILES)
LIST(SORT TDD_TEXT_FILES)
LIST(REMOVE_DUPLICATES TDD_VARIANTS)
LIST(SORT TDD_VARIANTS)

FILE(MAKE_DIRECTORY ${TDD_OUTPUT_DIRECTORY})


# ###### Create unique target name from file name ###########################
FUNCTION(makeUniqueTarget target fileName)
   # STRING(MAKE_C_IDENTIFIER ${fileName} result)
   SET(result ${fileName})
   STRING(REGEX REPLACE "[/\\ ]" "-"  result ${result})
   STRING(REPLACE "ä" "ae" result ${result})
   STRING(REPLACE "ö" "oe" result ${result})
   STRING(REPLACE "ü" "ue" result ${result})
   STRING(REPLACE "ß" "ss" result ${result})
   STRING(REPLACE "Ä" "AE" result ${result})
   STRING(REPLACE "Ö" "OE" result ${result})
   STRING(REPLACE "Ü" "UE" result ${result})
   STRING(REPLACE "æ" "ae" result ${result})
   STRING(REPLACE "ø" "oe" result ${result})
   STRING(REPLACE "å" "aa" result ${result})
   STRING(REPLACE "Æ" "AE" result ${result})
   STRING(REPLACE "Ø" "OE" result ${result})
   STRING(REPLACE "Å" "AA" result ${result})
   STRING(REGEX REPLACE "[áàǎã]" "a" result ${result})
   STRING(REGEX REPLACE "[ÁÀǍÃ]" "A" result ${result})
   STRING(REGEX REPLACE "[éèê]"  "e" result ${result})
   STRING(REGEX REPLACE "[ÉÈÊ]"  "E" result ${result})
   STRING(REGEX REPLACE "[^a-zA-Z0-9\\.@_+-]" "_X_" result ${result})
   SET(${target} ${result} PARENT_SCOPE)
ENDFUNCTION()


# ###### Initialise GIMP directory ##########################################
# Due to parallel runs of Gimp, make sure that gimp runs once allone first!
SET(GIMP_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${TDD_OUTPUT_DIRECTORY}/.gimp)
FILE(MAKE_DIRECTORY ${GIMP_DIRECTORY})
FILE(MAKE_DIRECTORY ${GIMP_DIRECTORY}/./gradients)   # For some reason, Gimp 2.10 does not create this directory but complains about it.
SET(gimpDirStamp "${GIMP_DIRECTORY}/gimp.stamp")
ADD_CUSTOM_COMMAND(OUTPUT  ${gimpDirStamp}
                   COMMAND env GIMP2_DIRECTORY=${GIMP_DIRECTORY} GIMP3_DIRECTORY=${GIMP_DIRECTORY} ${TEST_GIMP}
                   COMMAND touch ${gimpDirStamp})
ADD_CUSTOM_TARGET(generate_gimpDirStamp DEPENDS ${gimpDirStamp})


# ###### Generate text images ###############################################
FILE(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${TDD_OUTPUT_DIRECTORY}/Text)
FOREACH(textFile IN LISTS TDD_TEXT_FILES)
   STRING(REGEX REPLACE ".text$" ".png" textImage "${textFile}")
   GET_FILENAME_COMPONENT(textImage ${textImage} NAME)

   ADD_CUSTOM_COMMAND(OUTPUT  ${CMAKE_CURRENT_BINARY_DIR}/${TDD_OUTPUT_DIRECTORY}/Text/${textImage}
                      COMMAND env GIMP2_DIRECTORY=${GIMP_DIRECTORY} GIMP3_DIRECTORY=${GIMP_DIRECTORY} MAKE_GLOSSYTEXT="${MAKE_GLOSSYTEXT}" OUTPUT="${CMAKE_CURRENT_BINARY_DIR}/${TDD_OUTPUT_DIRECTORY}/Text/${textImage}" ${BASH} ${textFile}
                      DEPENDS ${textFile}
                              generate_gimpDirStamp
                              ${gimpDirStamp})
   LIST(APPEND all_texts ${CMAKE_CURRENT_BINARY_DIR}/${TDD_OUTPUT_DIRECTORY}/Text/${textImage})
ENDFOREACH()
ADD_CUSTOM_TARGET(generate_all_texts DEPENDS ${all_texts})
# NOTE: all_texts is a LIST, while generate_all_texts is a TARGET!
# In the following, "DEPENDS generate_all_texts ${all_texts}" can be used.


# ###### Prepare input images ###############################################
SET(originalsDir "${CMAKE_INSTALL_DATADIR}/${TDD_INSTALL_SUBDIRECTORY}/${TDD_OUTPUT_ORIGINALS}")
FOREACH(image IN LISTS TDD_IMAGE_FILES)
   # ====== Install original ================================================
   IF(INSTALL_ORIGINALS)
      INSTALL(FILES ${image} DESTINATION ${originalsDir})
   ENDIF()

   # ====== Generate hostname graphics ======================================
   GET_FILENAME_COMPONENT(imageName ${image} NAME_WE)
   IF(imageName MATCHES ^[a-z])
      SET(hostname      "${imageName}.${TDD_DOMAIN}")
      SET(hostnameImage "${CMAKE_CURRENT_BINARY_DIR}/${TDD_OUTPUT_DIRECTORY}/Text/${hostname}.png")
      makeUniqueTarget(generate_hostnameImage "generate_${hostname}.png")

      ADD_CUSTOM_COMMAND(OUTPUT  ${hostnameImage}
                         COMMAND env GIMP2_DIRECTORY=${GIMP_DIRECTORY} GIMP3_DIRECTORY=${GIMP_DIRECTORY} ${MAKE_GLOSSYTEXT} ${hostnameImage} "${hostname}" 256 10 "Brushed Aluminium" "Comic Sans MS"
                         DEPENDS generate_gimpDirStamp
                                 ${gimpDirStamp})
      ADD_CUSTOM_TARGET(${generate_hostnameImage} DEPENDS ${hostnameImage})
   ENDIF()
ENDFOREACH()


# ###### Generate caption image #############################################
FILE(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${TDD_OUTPUT_DIRECTORY}/${TDD_OUTPUT_OVERLAY})
FILE(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${TDD_OUTPUT_DIRECTORY}/${TDD_OUTPUT_SPLASH})

SET(captionFile "${CMAKE_CURRENT_BINARY_DIR}/${TDD_OUTPUT_DIRECTORY}/${TDD_OUTPUT_SPLASH}/${TDD_OUTPUT_CAPTIONFILE}")
makeUniqueTarget(generate_captionFile "generate_Caption.input")
FILE(GENERATE OUTPUT ${captionFile} CONTENT "${TDD_BOOTSPLASH_TEXT}")
ADD_CUSTOM_TARGET(${generate_captionFile} DEPENDS ${captionFile})
IF(BUILD_BOOTSPLASH)
   INSTALL(FILES ${captionFile} DESTINATION "${CMAKE_INSTALL_DATADIR}/${TDD_INSTALL_SUBDIRECTORY}/${TDD_OUTPUT_SPLASH}")
ENDIF()

FOREACH(resolution IN LISTS TDD_BOOTSPLASH_RESOLUTIONS)
   SET(imageCaption "${CMAKE_CURRENT_BINARY_DIR}/${TDD_OUTPUT_DIRECTORY}/${TDD_OUTPUT_OVERLAY}/Caption-${resolution}.png")
   makeUniqueTarget(generate_imageCaption "generate_Caption-${resolution}.png")
   STRING(REGEX REPLACE "x.*$" "" bootsplash_width  "${resolution}")
   STRING(REGEX REPLACE "^.*x" "" bootsplash_height "${resolution}")
   ADD_CUSTOM_COMMAND(OUTPUT  ${imageCaption}
                      COMMAND env GIMP2_DIRECTORY=${GIMP_DIRECTORY} GIMP3_DIRECTORY=${GIMP_DIRECTORY} MAKE_CAPTION=${MAKE_CAPTION} ${BUILD_CAPTION} ${imageCaption} ${captionFile} ${bootsplash_width} ${bootsplash_height}
                      DEPENDS ${generate_captionFile}
                              ${captionFile}
                              generate_gimpDirStamp
                              ${gimpDirStamp}
                              ${BUILD_CAPTION})
   ADD_CUSTOM_TARGET(${generate_imageCaption} DEPENDS ${imageCaption})
ENDFOREACH()


# ###### Generate desktop graphics ##########################################
FILE(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${TDD_OUTPUT_DIRECTORY}/${TDD_OUTPUT_WITH_LOGO})
FILE(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${TDD_OUTPUT_DIRECTORY}/${TDD_OUTPUT_WITHOUT_LOGO})
IF(BUILD_MIRRORED)
   FILE(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${TDD_OUTPUT_DIRECTORY}/${TDD_OUTPUT_MIRRORED_WITH_LOGO})
   FILE(MAKE_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}/${TDD_OUTPUT_DIRECTORY}/${TDD_OUTPUT_MIRRORED_WITHOUT_LOGO})
ENDIF()
FOREACH(resolution IN LISTS TDD_RESOLUTIONS)

   # ====== Set variables ===================================================
   STRING(REGEX REPLACE "x.*$" "" width  "${resolution}")
   STRING(REGEX REPLACE "^.*x" "" height "${resolution}")
   STRING(REGEX REPLACE "x" ":"   aspectRatio "${resolution}")

   MATH(EXPR hostnameHeight "${height}/20")   # 5% of height
   MATH(EXPR hostnameIndent "${height}/40")   # 2.5% of height


   # ====== Generate overlay graphics =======================================
   SET(overlayImage "${CMAKE_CURRENT_BINARY_DIR}/${TDD_OUTPUT_DIRECTORY}/${TDD_OUTPUT_OVERLAY}/Overlay-${resolution}.png")
   makeUniqueTarget(generate_overlayImage "generate_overlayImage-${resolution}.png")

   # NOTE: Dependency on generate targets and files!
   ADD_CUSTOM_COMMAND(OUTPUT ${overlayImage}
                      COMMAND env GIMP2_DIRECTORY=${GIMP_DIRECTORY} GIMP3_DIRECTORY=${GIMP_DIRECTORY} ${BUILD_OVERLAY} ${overlayImage} ${width} ${height} ${CMAKE_CURRENT_BINARY_DIR}/${TDD_OUTPUT_DIRECTORY}/Text
                      DEPENDS generate_all_texts
                              ${all_texts}
                              ${BUILD_OVERLAY})
   ADD_CUSTOM_TARGET(${generate_overlayImage} DEPENDS ${overlayImage})


   # ====== Process images ==================================================
   FOREACH(image IN LISTS TDD_IMAGE_FILES)

      # ====== Generate overlay graphics with hostname ======================
      GET_FILENAME_COMPONENT(imageName ${image} NAME_WE)
      IF(imageName MATCHES ^[a-z])
         SET(hostname      "${imageName}.${TDD_DOMAIN}")
         SET(hostnameImage "${CMAKE_CURRENT_BINARY_DIR}/${TDD_OUTPUT_DIRECTORY}/Text/${hostname}.png")
         makeUniqueTarget(generate_hostnameImage "generate_${hostname}.png")

         SET(overlayImageWithHostname "${CMAKE_CURRENT_BINARY_DIR}/${TDD_OUTPUT_DIRECTORY}/${TDD_OUTPUT_OVERLAY}/Overlay-${hostname}-${resolution}.png")
         makeUniqueTarget(generate_overlayImageWithHostname "generate_overlayImageWithHostname-${hostname}-${resolution}.png")

         # NOTE: Dependency on generate targets and files!
         ADD_CUSTOM_COMMAND(OUTPUT ${overlayImageWithHostname}
                           COMMAND ${GM} composite -gravity North -geometry +0+${hostnameIndent} -resize x${hostnameHeight} ${hostnameImage} ${overlayImage} ${overlayImageWithHostname}
                           DEPENDS ${generate_hostnameImage}
                                   ${hostnameImage}
                                   ${generate_overlayImage}
                                   ${overlayImage})
         ADD_CUSTOM_TARGET(${generate_overlayImageWithHostname} DEPENDS ${overlayImageWithHostname})
      ENDIF()


      # ====== Generate backgrounds =========================================
      FOREACH(variant IN LISTS TDD_VARIANTS)
         # ====== Extract name and extension ================================
         GET_FILENAME_COMPONENT(imageName      ${image} NAME_WE)
         GET_FILENAME_COMPONENT(imageExtension ${image} EXT)
         STRING(TOLOWER ${imageExtension} imageExtension)
         IF(imageExtension STREQUAL ".jpg")
            SET(imageExtension ".jpeg")
         ENDIF()


         # ====== Without logo ==============================================
         IF(FLAT_DIRECTORY_STRUCTURE)
            SET(dirWithoutLogo             "${CMAKE_CURRENT_BINARY_DIR}/${TDD_OUTPUT_DIRECTORY}/${TDD_OUTPUT_WITHOUT_LOGO}")
            SET(imageWithoutLogo           "${dirWithoutLogo}/${imageName}-${resolution}-${variant}${imageExtension}")
            SET(instDirWithoutLogo         "${CMAKE_INSTALL_DATADIR}/${TDD_INSTALL_SUBDIRECTORY}/${TDD_OUTPUT_WITHOUT_LOGO}")
            SET(dirMirroredWithoutLogo     "${CMAKE_CURRENT_BINARY_DIR}/${TDD_OUTPUT_DIRECTORY}/${TDD_OUTPUT_MIRRORED_WITHOUT_LOGO}")
            SET(imageMirroredWithoutLogo   "${dirMirroredWithoutLogo}/${imageName}-${resolution}-${variant}${imageExtension}")
            SET(instDirMirroredWithoutLogo "${CMAKE_INSTALL_DATADIR}/${TDD_INSTALL_SUBDIRECTORY}/${TDD_OUTPUT_MIRRORED_WITHOUT_LOGO}")
         ELSE()
            SET(dirWithoutLogo             "${CMAKE_CURRENT_BINARY_DIR}/${TDD_OUTPUT_DIRECTORY}/${TDD_OUTPUT_WITHOUT_LOGO}/${resolution}/${variant}")
            SET(imageWithoutLogo           "${dirWithoutLogo}/${imageName}${imageExtension}")
            SET(instDirWithoutLogo         "${CMAKE_INSTALL_DATADIR}/${TDD_INSTALL_SUBDIRECTORY}/${TDD_OUTPUT_WITHOUT_LOGO}/${resolution}/${variant}")
            SET(dirMirroredWithoutLogo     "${CMAKE_CURRENT_BINARY_DIR}/${TDD_OUTPUT_DIRECTORY}/${TDD_OUTPUT_MIRRORED_WITHOUT_LOGO}/${resolution}/${variant}")
            SET(imageMirroredWithoutLogo   "${dirMirroredWithoutLogo}/${imageName}${imageExtension}")
            SET(instDirMirroredWithoutLogo "${CMAKE_INSTALL_DATADIR}/${TDD_INSTALL_SUBDIRECTORY}/${TDD_OUTPUT_MIRRORED_WITHOUT_LOGO}/${resolution}/${variant}")
         ENDIF()
         makeUniqueTarget(generate_imageWithoutLogo "generate_${imageName}-without-Logo-${variant}-${resolution}${imageExtension}")

         FILE(MAKE_DIRECTORY ${dirWithoutLogo})
         SET(imageTemp2 ${imageWithoutLogo}-tmp2.png)   # Processed image
         SET(imageTemp1 ${imageWithoutLogo}-tmp1.png)   # Processed and cropped image

         # ------ Plain -----------------------------------------------------
         IF(variant STREQUAL "plain")
            IF(imageExtension STREQUAL ".png")
               ADD_CUSTOM_COMMAND(OUTPUT  ${imageWithoutLogo}
                                  COMMAND env GIMP2_DIRECTORY=${GIMP_DIRECTORY} GIMP3_DIRECTORY=${GIMP_DIRECTORY} ${MAKE_CROPPED}    ${image} ${imageTemp2} ${aspectRatio} ${width}
                                  COMMAND env GIMP2_DIRECTORY=${GIMP_DIRECTORY} GIMP3_DIRECTORY=${GIMP_DIRECTORY} ${MAKE_BUMPMAP} ${imageTemp2} ${imageTemp1}
                                  COMMAND ${GM} convert ${imageTemp1} -interlace line ${imageWithoutLogo}
                                  COMMAND ${EXIFTOOL} -m -q -overwrite_original -Copyright="${TDD_COPYRIGHT}" ${imageWithoutLogo} || true
                                  COMMAND ${RM} -f ${imageTemp1} ${imageTemp2}
                                  DEPENDS ${image}
                                          generate_gimpDirStamp
                                          ${gimpDirStamp})
            ELSE()
               ADD_CUSTOM_COMMAND(OUTPUT  ${imageWithoutLogo}
                                  COMMAND env GIMP2_DIRECTORY=${GIMP_DIRECTORY} GIMP3_DIRECTORY=${GIMP_DIRECTORY} ${MAKE_CROPPED} ${image} ${imageTemp1} ${aspectRatio} ${width}
                                  COMMAND ${GM} convert ${imageTemp1} -interlace line ${imageWithoutLogo}
                                  COMMAND ${EXIFTOOL} -m -q -overwrite_original -Copyright="${TDD_COPYRIGHT}" ${imageWithoutLogo} || true
                                  COMMAND ${RM} -f ${imageTemp1} ${imageTemp2}
                                  DEPENDS ${image}
                                          generate_gimpDirStamp
                                          ${gimpDirStamp})
            ENDIF()

         # ------ Oil Painting ----------------------------------------------
         ELSEIF(variant STREQUAL "oil")
            EXECUTE_PROCESS(COMMAND ${AWK} "BEGIN { print int((8*${width})/1024 + 0.5) }" OUTPUT_VARIABLE maskSize OUTPUT_STRIP_TRAILING_WHITESPACE)
            # MESSAGE("Painting: ${width} -> ${maskSize}")
            ADD_CUSTOM_COMMAND(OUTPUT  ${imageWithoutLogo}
                               COMMAND env GIMP2_DIRECTORY=${GIMP_DIRECTORY} GIMP3_DIRECTORY=${GIMP_DIRECTORY} ${MAKE_CROPPED}  ${image} ${imageTemp2} ${aspectRatio} ${width}
                               COMMAND env GIMP2_DIRECTORY=${GIMP_DIRECTORY} GIMP3_DIRECTORY=${GIMP_DIRECTORY} ${MAKE_OILPAINTING} ${imageTemp2} ${imageTemp1} ${makeSize}
                               COMMAND ${GM} convert ${imageTemp1} -interlace line ${imageWithoutLogo}
                               COMMAND ${EXIFTOOL} -m -q -overwrite_original -Copyright="${TDD_COPYRIGHT}" ${imageWithoutLogo} || true
                               COMMAND ${RM} -f ${imageTemp1} ${imageTemp2}
                               DEPENDS ${image}
                                       generate_gimpDirStamp
                                       ${gimpDirStamp})

         # ------ Mosaic ----------------------------------------------------
         ELSEIF(variant STREQUAL "mosaic")
            EXECUTE_PROCESS(COMMAND ${AWK} "BEGIN { print int((5.5*${width})/1024  + 0.5) }" OUTPUT_VARIABLE tileSize   OUTPUT_STRIP_TRAILING_WHITESPACE)
            EXECUTE_PROCESS(COMMAND ${AWK} "BEGIN { print int((1.0*${height})/1024 + 0.5) }" OUTPUT_VARIABLE tileHeight OUTPUT_STRIP_TRAILING_WHITESPACE)
            IF(${tileSize} LESS 3)
               SET(tileSize 3)
            ENDIF()
            IF(${tileHeight} LESS 1)
               SET(tileHeight 1)
            ENDIF()
            # MESSAGE("Mosaic: ${width} ${height} -> ${tileSize} ${tileHeight}")
            ADD_CUSTOM_COMMAND(OUTPUT  ${imageWithoutLogo}
                               COMMAND env GIMP2_DIRECTORY=${GIMP_DIRECTORY} GIMP3_DIRECTORY=${GIMP_DIRECTORY} ${MAKE_CROPPED} ${image} ${imageTemp2} ${aspectRatio} ${width}
                               COMMAND env GIMP2_DIRECTORY=${GIMP_DIRECTORY} GIMP3_DIRECTORY=${GIMP_DIRECTORY} ${MAKE_MOSAIC}  ${imageTemp2} ${imageTemp1} ${tileSize} ${tileHeight} ${tileHeight} --type hexagons --surface rough
                               COMMAND ${GM} convert ${imageTemp1} -interlace line ${imageWithoutLogo}
                               COMMAND ${EXIFTOOL} -m -q -overwrite_original -Copyright="${TDD_COPYRIGHT}" ${imageWithoutLogo} || true
                               COMMAND ${RM} -f ${imageTemp1} ${imageTemp2}
                               DEPENDS ${image}
                                       generate_gimpDirStamp
                                       ${gimpDirStamp})

         # ------ Cloth -----------------------------------------------------
         ELSEIF(variant STREQUAL "cloth")
            ADD_CUSTOM_COMMAND(OUTPUT  ${imageWithoutLogo}
                               COMMAND env GIMP2_DIRECTORY=${GIMP_DIRECTORY} GIMP3_DIRECTORY=${GIMP_DIRECTORY} ${MAKE_CROPPED} ${image} ${imageTemp2} ${aspectRatio} ${width}
                               COMMAND env GIMP2_DIRECTORY=${GIMP_DIRECTORY} GIMP3_DIRECTORY=${GIMP_DIRECTORY} ${MAKE_CLOTH}   ${imageTemp2} ${imageTemp1} 5
                               COMMAND ${GM} convert ${imageTemp1} -interlace line ${imageWithoutLogo}
                               COMMAND ${EXIFTOOL} -m -q -overwrite_original -Copyright="${TDD_COPYRIGHT}" ${imageWithoutLogo} || true
                               COMMAND ${RM} -f ${imageTemp1} ${imageTemp2}
                               DEPENDS ${image}
                                       generate_gimpDirStamp
                                       ${gimpDirStamp})

         # ------ Old Photo -------------------------------------------------
         ELSEIF(variant STREQUAL "oldphoto")
            ADD_CUSTOM_COMMAND(OUTPUT  ${imageWithoutLogo}
                               COMMAND env GIMP2_DIRECTORY=${GIMP_DIRECTORY} GIMP3_DIRECTORY=${GIMP_DIRECTORY} ${MAKE_CROPPED}  ${image} ${imageTemp2} ${aspectRatio} ${width}
                               COMMAND env GIMP2_DIRECTORY=${GIMP_DIRECTORY} GIMP3_DIRECTORY=${GIMP_DIRECTORY} ${MAKE_OLDPHOTO} ${imageTemp2} ${imageTemp1} 20
                               COMMAND ${GM} convert ${imageTemp1} -interlace line ${imageWithoutLogo}
                               COMMAND ${EXIFTOOL} -m -q -overwrite_original -Copyright="${TDD_COPYRIGHT}" ${imageWithoutLogo} || true
                               COMMAND ${RM} -f ${imageTemp1} ${imageTemp2}
                               DEPENDS ${image}
                                       generate_gimpDirStamp
                                       ${gimpDirStamp})

         # ------ Error -----------------------------------------------------
         ELSE()
            MESSAGE(FATAL_ERROR "Invalid variant: ${variant}!")
         ENDIF()

         ADD_CUSTOM_TARGET(${generate_imageWithoutLogo} ALL DEPENDS ${imageWithoutLogo})
         INSTALL(FILES ${imageWithoutLogo} DESTINATION ${instDirWithoutLogo})


         # ====== With logo =================================================
         IF(FLAT_DIRECTORY_STRUCTURE)
            SET(dirWithLogo             "${CMAKE_CURRENT_BINARY_DIR}/${TDD_OUTPUT_DIRECTORY}/${TDD_OUTPUT_WITH_LOGO}")
            SET(imageWithLogo           "${dirWithLogo}/${imageName}-${resolution}-${variant}${imageExtension}")
            SET(instDirWithLogo         "${CMAKE_INSTALL_DATADIR}/${TDD_INSTALL_SUBDIRECTORY}/${TDD_OUTPUT_WITH_LOGO}")
            SET(dirMirroredWithLogo     "${CMAKE_CURRENT_BINARY_DIR}/${TDD_OUTPUT_DIRECTORY}/${TDD_OUTPUT_MIRRORED_WITH_LOGO}")
            SET(imageMirroredWithLogo   "${dirMirroredWithLogo}/${imageName}-${resolution}-${variant}${imageExtension}")
            SET(instDirMirroredWithLogo "${CMAKE_INSTALL_DATADIR}/${TDD_INSTALL_SUBDIRECTORY}/${TDD_OUTPUT_MIRRORED_WITH_LOGO}")
         ELSE()
            SET(dirWithLogo             "${CMAKE_CURRENT_BINARY_DIR}/${TDD_OUTPUT_DIRECTORY}/${TDD_OUTPUT_WITH_LOGO}/${resolution}/${variant}")
            SET(imageWithLogo           "${dirWithLogo}/${imageName}${imageExtension}")
            SET(instDirWithLogo         "${CMAKE_INSTALL_DATADIR}/${TDD_INSTALL_SUBDIRECTORY}/${TDD_OUTPUT_WITH_LOGO}/${resolution}/${variant}")
            SET(dirMirroredWithLogo     "${CMAKE_CURRENT_BINARY_DIR}/${TDD_OUTPUT_DIRECTORY}/${TDD_OUTPUT_MIRRORED_WITH_LOGO}/${resolution}/${variant}")
            SET(imageMirroredWithLogo   "${dirMirroredWithLogo}/${imageName}${imageExtension}")
            SET(instDirMirroredWithLogo "${CMAKE_INSTALL_DATADIR}/${TDD_INSTALL_SUBDIRECTORY}/${TDD_OUTPUT_MIRRORED_WITH_LOGO}/${resolution}/${variant}")
         ENDIF()
         makeUniqueTarget(generate_imageWithLogo "generate_${imageName}-with-Logo-${variant}-${resolution}${imageExtension}")
         FILE(MAKE_DIRECTORY ${dirWithLogo})

         # ------ With hostname ---------------------------------------------
         IF((INSERT_HOSTNAME) AND (imageName MATCHES ^[a-z]))
            ADD_CUSTOM_COMMAND(OUTPUT ${imageWithLogo}
                               COMMAND ${GM} composite ${overlayImageWithHostname} ${imageWithoutLogo} -interlace line -quality ${TDD_JPEG_QUALITY} ${imageWithLogo}
                               COMMAND ${EXIFTOOL} -m -q -overwrite_original -Copyright="${TDD_COPYRIGHT}" ${imageWithLogo} || true
                               DEPENDS ${generate_overlayImageWithHostname}
                                       ${overlayImageWithHostname}
                                       ${generate_imageWithoutLogo}
                                       ${imageWithoutLogo})

         # ------ Without hostname ------------------------------------------
         ELSE()
            ADD_CUSTOM_COMMAND(OUTPUT ${imageWithLogo}
                               COMMAND ${GM} composite ${overlayImage} ${imageWithoutLogo} -interlace line -quality ${TDD_JPEG_QUALITY} ${imageWithLogo}
                               COMMAND ${EXIFTOOL} -m -q -overwrite_original -Copyright="${TDD_COPYRIGHT}" ${imageWithLogo} || true
                               DEPENDS ${generate_overlayImage}
                                       ${overlayImage}
                                       ${generate_imageWithoutLogo}
                                       ${imageWithoutLogo})
         ENDIF()

         ADD_CUSTOM_TARGET(${generate_imageWithLogo} ALL DEPENDS ${imageWithLogo})
         INSTALL(FILES ${imageWithLogo} DESTINATION ${instDirWithLogo})


         # ====== Bootsplash ================================================
         IF((BUILD_BOOTSPLASH) AND (resolution IN_LIST TDD_BOOTSPLASH_RESOLUTIONS) AND (variant STREQUAL "${TDD_BOOTSPLASH_VARIANT}"))
            SET(imageCaption "${CMAKE_CURRENT_BINARY_DIR}/${TDD_OUTPUT_DIRECTORY}/${TDD_OUTPUT_OVERLAY}/Caption-${resolution}.png")
            makeUniqueTarget(generate_imageCaption "generate_Caption-${resolution}.png")
            SET(imageBootsplash "${CMAKE_CURRENT_BINARY_DIR}/${TDD_OUTPUT_DIRECTORY}/${TDD_OUTPUT_SPLASH}/${imageName}-${resolution}.jpeg")
            makeUniqueTarget(generate_imageBootsplash "generate_${imageName}-Splash-${resolution}.jpeg")

            ADD_CUSTOM_COMMAND(OUTPUT  ${imageBootsplash}
                               COMMAND ${GM} composite  -gravity South ${imageCaption} ${imageWithLogo} -quality ${TDD_JPEG_QUALITY} ${imageBootsplash}
                               COMMAND ${EXIFTOOL} -m -q -overwrite_original -Copyright="${TDD_COPYRIGHT}" ${imageBootsplash} || true
                               DEPENDS ${generate_imageCaption}
                                       ${imageCaption}
                                       ${generate_imageWithLogo}
                                       ${imageWithLogo})
            ADD_CUSTOM_TARGET(${generate_imageBootsplash} ALL DEPENDS ${imageBootsplash})
            INSTALL(FILES ${imageBootsplash} DESTINATION ${CMAKE_INSTALL_DATADIR}/${TDD_INSTALL_SUBDIRECTORY}/${TDD_OUTPUT_SPLASH})
         ENDIF()


         # ====== Print PDF DIN A4 ==========================================
         IF((PRINT_A4) AND
           (resolution STREQUAL "2970x2100") AND
           (variant STREQUAL "${TDD_PRINT_VARIANT}") AND
           ("${imageName}${imageExtension}" STREQUAL "${TDD_PRINT_IMAGE}"))
            SET(pdfA4          "${CMAKE_CURRENT_BINARY_DIR}/${TDD_OUTPUT_DIRECTORY}/${TDD_PRINT_PREFIX}-A4.pdf")
            makeUniqueTarget(generate_pdfA4 "generate_${TDD_PRINT_PREFIX}-A4.pdf")

            ADD_CUSTOM_COMMAND(OUTPUT ${pdfA4}
                              COMMAND ${GM} convert ${imageWithLogo} ${overlayImage} -units PixelsPerCentimeter -density 100x100 -page 2970x2100 -resize 2970x2100 -gravity center -compress lossless ${pdfA4}
                              DEPENDS ${generate_overlayImage}
                                      ${overlayImage}
                                      ${generate_imageWithLogo}
                                      ${imageWithLogo})
            ADD_CUSTOM_TARGET(${generate_pdfA4} ALL DEPENDS ${pdfA4})
            INSTALL(FILES ${pdfA4} DESTINATION ${CMAKE_INSTALL_DATADIR}/${TDD_INSTALL_SUBDIRECTORY})
         ENDIF()


         # ====== Print PDF DIN A3 ==========================================
         IF((PRINT_A3) AND
           (resolution STREQUAL "2970x2100") AND
           (variant STREQUAL "${TDD_PRINT_VARIANT}") AND
           ("${imageName}${imageExtension}" STREQUAL "${TDD_PRINT_IMAGE}"))
            SET(pdfA3          "${CMAKE_CURRENT_BINARY_DIR}/${TDD_OUTPUT_DIRECTORY}/${TDD_PRINT_PREFIX}-A3.pdf")
            makeUniqueTarget(generate_pdfA3 "generate_${TDD_PRINT_PREFIX}-A3.pdf")

            ADD_CUSTOM_COMMAND(OUTPUT ${pdfA3}
                              COMMAND ${GM} convert ${imageWithLogo} ${overlayImage} -units PixelsPerCentimeter -density 100x100 -page 5940x4200 -resize 5940x4200 -gravity center -compress lossless ${pdfA3}
                              DEPENDS ${generate_overlayImage}
                                      ${overlayImage}
                                      ${generate_imageWithLogo}
                                      ${imageWithLogo})
            ADD_CUSTOM_TARGET(${generate_pdfA3} ALL DEPENDS ${pdfA3})
            INSTALL(FILES ${pdfA3} DESTINATION ${CMAKE_INSTALL_DATADIR}/${TDD_INSTALL_SUBDIRECTORY})
         ENDIF()

         # ====== Mirrored version ==========================================
         IF(BUILD_MIRRORED)
            # ------ Mirrored image without logo ----------------------------
            SET(mirroredWithoutLogo   "${CMAKE_CURRENT_BINARY_DIR}/${TDD_OUTPUT_DIRECTORY}/${TDD_PRINT_PREFIX}-A3.pdf")
            makeUniqueTarget(generate_mirroredWithoutLogo "generate_${imageMirroredWithoutLogo}")

            ADD_CUSTOM_COMMAND(OUTPUT ${imageMirroredWithoutLogo}
                               COMMAND ${GM} convert ${imageWithoutLogo} -flop ${imageMirroredWithoutLogo}
                               DEPENDS ${generate_imageWithoutLogo})

            ADD_CUSTOM_TARGET(${generate_mirroredWithoutLogo} ALL DEPENDS ${imageMirroredWithoutLogo})
            INSTALL(FILES ${imageMirroredWithoutLogo} DESTINATION ${CMAKE_INSTALL_DATADIR}/${TDD_INSTALL_SUBDIRECTORY})

            # ------ Mirrored image with logo -------------------------------
            SET(mirroredWithLogo   "${CMAKE_CURRENT_BINARY_DIR}/${TDD_OUTPUT_DIRECTORY}/${TDD_PRINT_PREFIX}-A3.pdf")
            makeUniqueTarget(generate_mirroredWithLogo "generate_${imageMirroredWithLogo}")

            ADD_CUSTOM_COMMAND(OUTPUT ${imageMirroredWithLogo}
                               COMMAND ${GM} convert ${imageWithLogo} -flop ${imageMirroredWithLogo}
                               DEPENDS ${generate_imageWithLogo})

            ADD_CUSTOM_TARGET(${generate_mirroredWithLogo} ALL DEPENDS ${imageMirroredWithLogo})
            INSTALL(FILES ${imageMirroredWithLogo} DESTINATION ${CMAKE_INSTALL_DATADIR}/${TDD_INSTALL_SUBDIRECTORY})
         ENDIF()

      ENDFOREACH()
   ENDFOREACH()
ENDFOREACH()


#############################################################################
# SOURCE DIRECTORIES
#############################################################################

IF(EXISTS ${CMAKE_CURRENT_SOURCE_DIR}/grub)
   ADD_SUBDIRECTORY(${CMAKE_CURRENT_SOURCE_DIR}/grub)
ENDIF()
