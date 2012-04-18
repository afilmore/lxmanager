/***********************************************************************************************************************
 * DesktopWindow.vala
 * 
 * Copyright 2012 Axel FILMORE <axel.filmore@gmail.com>
 * 
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License Version 2.
 * http://www.gnu.org/licenses/gpl-2.0.txt
 * 
 * This software is an experimental fork of PcManFm originally written by Hong Jen Yee aka PCMan for LXDE project.
 * 
 * Purpose: 
 * 
 * 
 **********************************************************************************************************************/
namespace Manager {
    
    /***********************************************************************************************
     * Desktop Window.
     * 
     * 
     **********************************************************************************************/
    public class Window : Gtk.Window {
        
        bool _debug_mode = false;
        
        
        public Window () {
            
            this.destroy.connect ( () => {
                
                Gtk.main_quit ();
            });
            
        }
        
        ~Window () {
            
        }

        
        /*********************************************************************************
         * Widget Creation...
         * 
         * 
         ********************************************************************************/
        public bool create (string config_file, bool debug = false) {
            
            _debug_mode = debug;
            
            if (_debug_mode) {
                
                /*************************************************************************
                 * Debug mode, show the desktop in a regular window, very handy :)
                 *
                 ************************************************************************/
                this.set_default_size ((screen.get_width() / 4) * 3, (screen.get_height() / 4) * 3);
                this.set_position (Gtk.WindowPosition.CENTER);
                this.set_app_paintable (true);

            } else {
                
                /*************************************************************************
                 * This is the normal running mode, full screen
                 *
                 ************************************************************************/
                this.set_default_size (screen.get_width(), screen.get_height());
                this.move (0, 0);
                this.set_app_paintable (true);
                this.set_type_hint (Gdk.WindowTypeHint.DESKTOP);
                
            }
            
            this.add_events (  Gdk.EventMask.POINTER_MOTION_MASK
                             | Gdk.EventMask.BUTTON_PRESS_MASK
                             | Gdk.EventMask.BUTTON_RELEASE_MASK
                             | Gdk.EventMask.KEY_PRESS_MASK
                             | Gdk.EventMask.PROPERTY_CHANGE_MASK);

            this.realize ();
            this.show_all ();
            
            return true;
        }
        
        /*********************************************************************************
         * *** Widget Signal Handlers ***
         * 
         *     Widget creation/sizing/drawing...
         * 
         * 
         ********************************************************************************/
        private void _on_realize () {
            
            /*** stdout.printf ("_on_realize\n"); ***/
            
            base.realize ();
            
            
        }

        private void _on_size_allocate (Gdk.Rectangle rect) {
            
            /*** stdout.printf ("_on_size_allocate: %i, %i, %i, %i\n", rect.x, rect.y, rect.width, rect.height); ***/
            
            base.size_allocate (rect);
        }

        private void _on_size_request (Gtk.Requisition req) {
            
            Gdk.Screen screen = this.get_screen ();
            if (_debug_mode == true ) {
                req.width = (screen.get_width () /4) *3;
                req.height = (screen.get_height () /4) *3;
            } else {
                req.width = screen.get_width ();
                req.height = screen.get_height ();
            }
            
            /*** stdout.printf ("_on_size_request: %i, %i\n", req.width, req.height); ***/
        }

        private bool _on_expose (Gdk.EventExpose evt) {
            
            /*** stdout.printf ("_on_expose: visible=%u, mapped=%u\n",
                                (uint) this.get_visible (),
                                (uint) this.get_mapped ()); ***/
            
            if (this.get_visible () == false || this.get_mapped () == false)
                return true;

            return true;
        }
    }
}


