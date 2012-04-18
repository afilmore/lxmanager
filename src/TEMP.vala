/***********************************************************************************************************************
 * TEMP.vala
 * 
 * Copyright 2012 Axel FILMORE <axel.filmore@gmail.com>
 * 
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License Version 2.
 * http://www.gnu.org/licenses/gpl-2.0.txt
 * 
 * This software is a simple file manager originally based on LibFm Demo :
 * http://pcmanfm.git.sourceforge.net/git/gitweb.cgi?p=pcmanfm/libfm;a=blob;f=src/demo/main-win.c
 * 
 * Purpose: These are currently not translated to Vala, commented or simply unused functions. Most of these are empty
 * and useless but this file is included in the program and built with it. Some of these will never be used, but some
 * may be translated, adapted and moved into the application's classes.
 * 
 * 
 **********************************************************************************************************************/
int main(int argc, char** argv)
{
	GtkWidget* w;
	gtk_init(&argc, &argv);

	fm_gtk_init(NULL);

    /* for debugging RTL */
    /* gtk_widget_set_default_direction(GTK_TEXT_DIR_RTL); */

	w = fm_main_win_new();
	gtk_window_set_default_size(GTK_WINDOW(w), 640, 480);
	gtk_widget_show(w);

    if(argc > 1)
    {
        FmPath* path = fm_path_new_for_str(argv[1]);
        fm_main_win_chdir(FM_MAIN_WIN(w), path);
        fm_path_unref(path);
    }

	gtk_main();

    fm_finalize();

	return 0;
}
/* ********************************************************************************************************************/
private void on_bookmark (GtkMenuItem* mi) {

    FmPath* path =  (FmPath*)g_object_get_data (G_OBJECT (mi), "path");
    chdir (win, path);
}

private void create_bookmarks_menu () {

    GList* l;
    int i = 0;
    // FIXME: direct access to data member is not allowed 
    for (l=win->bookmarks->items;l;l=l->next)
    {
        FmBookmarkItem* item =  (FmBookmarkItem*)l->data;
        GtkWidget* mi = gtk_image_menu_item_new_with_label (item->name);
        gtk_widget_show (mi);
        // gtk_image_menu_item_set_image (); // FIXME: set icons for menu items
        g_object_set_qdata_full (G_OBJECT (mi), fm_qdata_id, fm_path_ref (item->path),  (GDestroyNotify)fm_path_unref);
        g_signal_connect (mi, "activate", G_CALLBACK (on_bookmark), win);
        gtk_menu_shell_insert (GTK_MENU_SHELL (win->bookmarks_menu), mi, i);
        ++i;
    }
    if (i > 0)
        gtk_menu_shell_insert (GTK_MENU_SHELL (win->bookmarks_menu), gtk_separator_menu_item_new (), i);
}

private void on_bookmarks_changed (FmBookmarks* bm) {

    // delete old items first. 
    GList* mis = gtk_container_get_children (GTK_CONTAINER (win->bookmarks_menu));
    GList* l;
    for (l = mis;l;l=l->next)
    {
        GtkWidget* item =  (GtkWidget*)l->data;
        if ( GTK_IS_SEPARATOR_MENU_ITEM (item) )
            break;
        gtk_widget_destroy (item);
    }
    g_list_free (mis);

    create_bookmarks_menu (win);
}

private void load_bookmarks (, GtkUIManager* ui) {

    GtkWidget* mi = gtk_ui_manager_get_widget (ui, "/menubar/BookmarksMenu");
    win->bookmarks_menu = gtk_menu_item_get_submenu (GTK_MENU_ITEM (mi));
    win->bookmarks = fm_bookmarks_get ();
    g_signal_connect (win->bookmarks, "changed", G_CALLBACK (on_bookmarks_changed), win);

    create_bookmarks_menu (win);
}

private void on_history_item (GtkMenuItem* mi) {

    GList* l = g_object_get_qdata (G_OBJECT (mi), fm_qdata_id);
    const FmNavHistoryItem* item =  (FmNavHistoryItem*)l->data;
    int scroll_pos = gtk_adjustment_get_value (gtk_scrolled_window_get_vadjustment (GTK_SCROLLED_WINDOW (win->folder_view)));
    fm_nav_history_jump (win->nav_history, l, scroll_pos);
    item = fm_nav_history_get_cur (win->nav_history);
    // FIXME: should this be driven by a signal emitted on FmNavHistory? 
    chdir_without_history (win, item->path);
}

private void on_show_history_menu (GtkMenuToolButton* btn) {

    GtkMenuShell* menu =  (GtkMenuShell*)gtk_menu_tool_button_get_menu (btn);
    GList* l;
    GList* cur = fm_nav_history_get_cur_link (win->nav_history);

    // delete old items 
    gtk_container_foreach (GTK_CONTAINER (menu),  (GtkCallback)gtk_widget_destroy, NULL);

    for (l = fm_nav_history_list (win->nav_history); l; l=l->next)
    {
        const FmNavHistoryItem* item =  (FmNavHistoryItem*)l->data;
        FmPath* path = item->path;
        string str = fm_path_display_name (path, true);
        GtkMenuItem* mi;
        if ( l == cur )
        {
            mi = gtk_check_menu_item_new_with_label (str);
            gtk_check_menu_item_set_draw_as_radio (GTK_CHECK_MENU_ITEM (mi), true);
            gtk_check_menu_item_set_active (GTK_CHECK_MENU_ITEM (mi), true);
        }
        else
            mi = gtk_menu_item_new_with_label (str);
        g_free (str);

        g_object_set_qdata_full (G_OBJECT (mi), fm_qdata_id, l, NULL);
        g_signal_connect (mi, "activate", G_CALLBACK (on_history_item), win);
        gtk_menu_shell_append (menu, mi);
    }
    gtk_widget_show_all ( GTK_WIDGET (menu) );
}

void on_go_back (GtkAction* act) {

    if (fm_nav_history_get_can_back (win->nav_history))
    {
        FmNavHistoryItem* item;
        int scroll_pos = gtk_adjustment_get_value (gtk_scrolled_window_get_vadjustment (GTK_SCROLLED_WINDOW (win->folder_view)));
        fm_nav_history_back (win->nav_history, scroll_pos);
        item = fm_nav_history_get_cur (win->nav_history);
        // FIXME: should this be driven by a signal emitted on FmNavHistory? 
        chdir_without_history (win, item->path);
    }
}

void on_go_forward (GtkAction* act) {

    if (fm_nav_history_get_can_forward (win->nav_history))
    {
        FmNavHistoryItem* item;
        int scroll_pos = gtk_adjustment_get_value (gtk_scrolled_window_get_vadjustment (GTK_SCROLLED_WINDOW (win->folder_view)));
        fm_nav_history_forward (win->nav_history, scroll_pos);
        // FIXME: should this be driven by a signal emitted on FmNavHistory? 
        item = fm_nav_history_get_cur (win->nav_history);
        // FIXME: should this be driven by a signal emitted on FmNavHistory? 
        chdir_without_history (win, item->path);
    }
}

void on_create_new (GtkAction* action) {

    FmFolderView* fv = FM_FOLDER_VIEW (win->folder_view);
    const string name = gtk_action_get_name (action);
    GError* err = NULL;
    FmPath* cwd = fm_folder_view_get_cwd (fv);
    FmPath* dest;
    string basename;
_retry:
    basename = fm_get_user_input (GTK_WINDOW (win), _ ("Create New..."), _ ("Enter a name for the newly created file:"), _ ("New"));
    if (!basename)
        return;

    dest = fm_path_new_child (cwd, basename);
    g_free (basename);

    if ( strcmp (name, "NewFolder") == 0 )
    {
        GFile* gf = fm_path_to_gfile (dest);
        if (!g_file_make_directory (gf, NULL, &err))
        {
            if (err->domain = G_IO_ERROR && err->code == G_IO_ERROR_EXISTS)
            {
                fm_path_unref (dest);
                g_error_free (err);
                g_object_unref (gf);
                err = NULL;
                goto _retry;
            }
            fm_show_error (GTK_WINDOW (win), NULL, err->message);
            g_error_free (err);
        }

        if (!err) // select the newly created file 
        {
            //FIXME: this doesn't work since the newly created file will
            // only be shown after file-created event was fired on its
            //folder's monitor and after FmFolder handles it in idle
            //handler. So, we cannot select it since it's not yet in
            //the folder model now. 
            // fm_folder_view_select_file_path (fv, dest); 
        }
        g_object_unref (gf);
    }
    else if ( strcmp (name, "NewBlank") == 0 )
    {
        GFile* gf = fm_path_to_gfile (dest);
        GFileOutputStream* f = g_file_create (gf, G_FILE_CREATE_NONE, NULL, &err);
        if (f)
        {
            g_output_stream_close (G_OUTPUT_STREAM (f), NULL, NULL);
            g_object_unref (f);
        }
        else
        {
            if (err->domain = G_IO_ERROR && err->code == G_IO_ERROR_EXISTS)
            {
                fm_path_unref (dest);
                g_error_free (err);
                g_object_unref (gf);
                err = NULL;
                goto _retry;
            }
            fm_show_error (GTK_WINDOW (win), NULL, err->message);
            g_error_free (err);
        }

        if (!err) // select the newly created file 
        {
            //FIXME: this doesn't work since the newly created file will
             // only be shown after file-created event was fired on its
             // folder's monitor and after FmFolder handles it in idle
             // handler. So, we cannot select it since it's not yet in
             // the folder model now. 
            // fm_folder_view_select_file_path (fv, dest); 
        }
        g_object_unref (gf);
    }
    else // templates 
    {

    }
    fm_path_unref (dest);
}



