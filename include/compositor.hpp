#ifndef __COMPOSITOR_H__
#define __COMPOSITOR_H__

#include <QObject>
#include <QQuickItem>
#include <QQuickWindow>
#include <QWaylandCompositor>
#include <QWaylandQuickOutput>

#include <vector>

#include "./window.hpp"

class Compositor {

  public:
    Compositor(QQuickWindow* window, QQuickItem* board, const char* socket_name);

  private:
    void                  on_toplevel_created(QWaylandXdgToplevel* toplevel, QWaylandXdgSurface* xdgSurface);
    void                  on_surface_destroyed(QWaylandQuickShellSurfaceItem* item);

    QWaylandCompositor    m_compositor;
    QWaylandQuickOutput*  m_output;
    QWaylandXdgShell*     m_xdg_shell;
    QQuickItem*           m_board;

    std::vector<Window_t> m_windows;
    int                   m_current_workspace = 0;
};

#endif