/***********************************************************************************************************************
 * Application.vala
 * 
 * Copyright 2012 Axel FILMORE <axel.filmore@gmail.com>
 * 
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License Version 2.
 * http://www.gnu.org/licenses/gpl-2.0.txt
 * 
 * This software is an experimental fork of PcManFm originally written by Hong Jen Yee aka PCMan for LXDE project.
 * 
 * Purpose: The Main Application Class and program's entry point.
 * 
 * 
 * 
 **********************************************************************************************************************/
namespace Manager {

    Application     global_app;
    Desktop.Config? global_config;
    bool            global_debug_mode;
        
    public const OptionEntry[] opt_entries = {
        
        {"debug",   'd',    0,  OptionArg.NONE, ref global_debug_mode,  N_("Run In Debug Mode"), null},
        {null}
    };

    public class Application {
        
        bool _debug_mode = false;
        

        public Application () {
        }
        
        public bool run (bool debug = false) {
            
            _debug_mode = debug;

            Manager.Window manager = new Manager.Window ();
            manager.create ("", true);
            
            Gtk.main ();
            
            return true;
        }
        
        
        /***************************************************************************************************************
         * Application's entry point.
         *
         * 
         * 
         **************************************************************************************************************/
        private static int main (string[] args) {
            
            try {
                Gtk.init_with_args (ref args, "", opt_entries, VConfig.GETTEXT_PACKAGE);
            } catch {
            }
            
            // Create the Desktop configuration, this object derivates of Fm.Config.
            global_config = new Desktop.Config ();
            
            global_app = new Application ();
            
            GLib.Application unique = new GLib.Application ("org.noname.lxmanager", 0);
            unique.register ();
            
            if (!unique.get_is_remote () || global_debug_mode) {
                
                Fm.init (global_config);
                /*** fm_volume_manager_init (); ***/

                global_app.run (global_debug_mode);
            
                /*** fm_volume_manager_finalize (); ***/
                Fm.finalize ();
            
            } else {
                
                stdout.printf ("already running !!!!\n");
            }
            
            return 0;
        }
    }
}


