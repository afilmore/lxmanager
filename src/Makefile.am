NULL=

AM_CPPFLAGS = \
	-include config.h \
	-DPACKAGE_DATA_DIR=\""$(datadir)/desk2"\" \
	-DPACKAGE_UI_DIR=\""$(datadir)/desk2/ui"\" \
	-DPACKAGE_LOCALE_DIR=\""$(prefix)/$(DATADIRNAME)/locale"\" \
	$(NULL)

bin_PROGRAMS = lxmanager

exo_SOURCES = \
	gtk/exo/exo-icon-view.c \
	gtk/exo/exo-private.c \
	gtk/exo/exo-tree-view.c \
	gtk/exo/exo-marshal.c \
	gtk/exo/exo-string.c \
	$(NULL)

gtk_SOURCES = \
	gtk/fm-dir-tree-model.c \
	gtk/fm-dir-tree-view.c \
	gtk/fm-folder-view.c \
	gtk/fm-cell-renderer-text.c \
	$(NULL)

TEMP = \
	gtk/fm-places-model.c \
	gtk/fm-places-view.c \
	gtk/fm-places-view.h
	gtk/fm-places-model.h
	gtk/fm-folder-view.h
	gtk/fm-dir-tree-view.h
	gtk/fm-dir-tree-model.h
	gtk/exo/exo-icon-view.h \
	gtk/exo/exo-private.h \
	gtk/exo/exo-marshal.h \
	gtk/exo/exo-string.h \
	gtk/exo/exo-tree-view.h \
	$(NULL)
	
lxmanager_SOURCES = \
	DesktopConfig.vala \
	Application.vala \
	ManagerWindow.vala \
	TEMP.vala \
	$(exo_SOURCES) \
	$(gtk_SOURCES) \
	$(NULL)

lxmanager_VALAFLAGS = \
	--vapidir=$(top_srcdir)/vapi \
	--pkg vconfig \
	--pkg gtk+-2.0 \
	--pkg libfmcore \
	$(NULL)

lxmanager_CFLAGS = \
	$(XLIB_CFLAGS) \
	$(GTK_CFLAGS) \
	$(PANGO_CFLAGS) \
	$(GLIB_CFLAGS) \
	$(GIO_CFLAGS) \
	$(GMODULE_CFLAGS) \
	$(FM_CFLAGS) \
	$(MENU_CACHE_CFLAGS) \
	$(G_CAST_CHECKS) \
	-Wall \
	-Werror-implicit-function-declaration \
	$(NULL)

lxmanager_LDADD = \
	$(XLIB_LIBS) \
	$(GTK_LIBS) \
	$(PANGO_LIBS) \
	$(GLIB_LIBS) \
	$(GIO_LIBS) \
	$(GMODULE_LIBS) \
	$(FM_LIBS) \
	$(MENU_CACHE_LIBS) \
	$(NULL)

CLEANFILES = $(patsubst %.vala,%.c,$(filter %.vala, $(SOURCES))) lxmanager.stamp

