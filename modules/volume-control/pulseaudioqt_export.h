#ifndef PULSEAUDIOQT_EXPORT_H
#define PULSEAUDIOQT_EXPORT_H

#include <QVariant>

#ifdef PULSEAUDIOQT_STATIC_DEFINE
#  define PULSEAUDIOQT_EXPORT
#  define PULSEAUDIOQT_NO_EXPORT
#else
#  ifndef PULSEAUDIOQT_EXPORT
#    ifdef KF5PulseAudioQt_EXPORTS
        /* We are building this library */
#      define PULSEAUDIOQT_EXPORT __attribute__((visibility("default")))
#    else
        /* We are using this library */
#      define PULSEAUDIOQT_EXPORT __attribute__((visibility("default")))
#    endif
#  endif

#  ifndef PULSEAUDIOQT_NO_EXPORT
#    define PULSEAUDIOQT_NO_EXPORT __attribute__((visibility("hidden")))
#  endif
#endif

#ifndef PULSEAUDIOQT_DECL_DEPRECATED
#  define PULSEAUDIOQT_DECL_DEPRECATED __attribute__ ((__deprecated__))
#endif

#ifndef PULSEAUDIOQT_DECL_DEPRECATED_EXPORT
#  define PULSEAUDIOQT_DECL_DEPRECATED_EXPORT PULSEAUDIOQT_EXPORT PULSEAUDIOQT_DECL_DEPRECATED
#endif

#ifndef PULSEAUDIOQT_DECL_DEPRECATED_NO_EXPORT
#  define PULSEAUDIOQT_DECL_DEPRECATED_NO_EXPORT PULSEAUDIOQT_NO_EXPORT PULSEAUDIOQT_DECL_DEPRECATED
#endif

#if 0 /* DEFINE_NO_DEPRECATED */
#  ifndef PULSEAUDIOQT_NO_DEPRECATED
#    define PULSEAUDIOQT_NO_DEPRECATED
#  endif
#endif

#define PULSEAUDIOQT_DECL_DEPRECATED_TEXT(text) __attribute__ ((__deprecated__(text)))

#define ECM_GENERATEEXPORTHEADER_VERSION_VALUE(major, minor, patch) ((major<<16)|(minor<<8)|(patch))

/* Take any defaults from group settings */
#if !defined(PULSEAUDIOQT_NO_DEPRECATED) && !defined(PULSEAUDIOQT_DISABLE_DEPRECATED_BEFORE_AND_AT)
#  ifdef KF_NO_DEPRECATED
#    define PULSEAUDIOQT_NO_DEPRECATED
#  elif defined(KF_DISABLE_DEPRECATED_BEFORE_AND_AT)
#    define PULSEAUDIOQT_DISABLE_DEPRECATED_BEFORE_AND_AT KF_DISABLE_DEPRECATED_BEFORE_AND_AT
#  endif
#endif
#if !defined(PULSEAUDIOQT_DISABLE_DEPRECATED_BEFORE_AND_AT) && defined(KF_DISABLE_DEPRECATED_BEFORE_AND_AT)
#  define PULSEAUDIOQT_DISABLE_DEPRECATED_BEFORE_AND_AT KF_DISABLE_DEPRECATED_BEFORE_AND_AT
#endif

#if !defined(PULSEAUDIOQT_NO_DEPRECATED_WARNINGS) && !defined(PULSEAUDIOQT_DEPRECATED_WARNINGS_SINCE)
#  ifdef KF_NO_DEPRECATED_WARNINGS
#    define PULSEAUDIOQT_NO_DEPRECATED_WARNINGS
#  elif defined(KF_DEPRECATED_WARNINGS_SINCE)
#    define PULSEAUDIOQT_DEPRECATED_WARNINGS_SINCE KF_DEPRECATED_WARNINGS_SINCE
#  endif
#endif
#if !defined(PULSEAUDIOQT_DEPRECATED_WARNINGS_SINCE) && defined(KF_DEPRECATED_WARNINGS_SINCE)
#  define PULSEAUDIOQT_DEPRECATED_WARNINGS_SINCE KF_DEPRECATED_WARNINGS_SINCE
#endif

#if defined(PULSEAUDIOQT_NO_DEPRECATED)
#  undef PULSEAUDIOQT_DEPRECATED
#  define PULSEAUDIOQT_DEPRECATED_EXPORT PULSEAUDIOQT_EXPORT
#  define PULSEAUDIOQT_DEPRECATED_NO_EXPORT PULSEAUDIOQT_NO_EXPORT
#elif defined(PULSEAUDIOQT_NO_DEPRECATED_WARNINGS)
#  define PULSEAUDIOQT_DEPRECATED
#  define PULSEAUDIOQT_DEPRECATED_EXPORT PULSEAUDIOQT_EXPORT
#  define PULSEAUDIOQT_DEPRECATED_NO_EXPORT PULSEAUDIOQT_NO_EXPORT
#else
#  define PULSEAUDIOQT_DEPRECATED PULSEAUDIOQT_DECL_DEPRECATED
#  define PULSEAUDIOQT_DEPRECATED_EXPORT PULSEAUDIOQT_DECL_DEPRECATED_EXPORT
#  define PULSEAUDIOQT_DEPRECATED_NO_EXPORT PULSEAUDIOQT_DECL_DEPRECATED_NO_EXPORT
#endif

/* No deprecated API had been removed from build */
#define PULSEAUDIOQT_EXCLUDE_DEPRECATED_BEFORE_AND_AT 0

#define PULSEAUDIOQT_BUILD_DEPRECATED_SINCE(major, minor) 1

#ifdef PULSEAUDIOQT_NO_DEPRECATED
#  define PULSEAUDIOQT_DISABLE_DEPRECATED_BEFORE_AND_AT 0x10200
#endif
#ifdef PULSEAUDIOQT_NO_DEPRECATED_WARNINGS
#  define PULSEAUDIOQT_DEPRECATED_WARNINGS_SINCE 0
#endif

#ifndef PULSEAUDIOQT_DEPRECATED_WARNINGS_SINCE
#  ifdef PULSEAUDIOQT_DISABLE_DEPRECATED_BEFORE_AND_AT
#    define PULSEAUDIOQT_DEPRECATED_WARNINGS_SINCE PULSEAUDIOQT_DISABLE_DEPRECATED_BEFORE_AND_AT
#  else
#    define PULSEAUDIOQT_DEPRECATED_WARNINGS_SINCE 0x10200
#  endif
#endif

#ifndef PULSEAUDIOQT_DISABLE_DEPRECATED_BEFORE_AND_AT
#  define PULSEAUDIOQT_DISABLE_DEPRECATED_BEFORE_AND_AT 0x10000
#endif

#ifdef PULSEAUDIOQT_DEPRECATED
#  define PULSEAUDIOQT_ENABLE_DEPRECATED_SINCE(major, minor) (ECM_GENERATEEXPORTHEADER_VERSION_VALUE(major, minor, 0) > PULSEAUDIOQT_DISABLE_DEPRECATED_BEFORE_AND_AT)
#else
#  define PULSEAUDIOQT_ENABLE_DEPRECATED_SINCE(major, minor) 0
#endif

#endif /* PULSEAUDIOQT_EXPORT_H */
