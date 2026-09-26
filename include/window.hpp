#ifndef __WINDOW_H__
#define __WINDOW_H__

#include <QWaylandQuickShellSurfaceItem>
#include <QWaylandXdgShell>

struct Window_t {
    QWaylandXdgToplevel*           toplevel;
    QWaylandXdgSurface*            xdgSurface;
    QWaylandQuickShellSurfaceItem* item;
    int                            workspace;
};

#endif