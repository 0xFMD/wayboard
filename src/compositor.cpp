#include "../include/compositor.hpp"

Compositor::Compositor(QQuickWindow* window, QQuickItem* board, const char* socket_name) {
    m_board = board;

    m_output = new QWaylandQuickOutput(&m_compositor, window);
    m_output->setSizeFollowsWindow(true);

    m_compositor.setSocketName(socket_name);
    m_compositor.setUseHardwareIntegrationExtension(false);
    m_compositor.create();

    m_xdg_shell = new QWaylandXdgShell(&m_compositor);

    QObject::connect(m_xdg_shell, &QWaylandXdgShell::toplevelCreated,
                     [this](QWaylandXdgToplevel* toplevel, QWaylandXdgSurface* xdgSurface) { on_toplevel_created(toplevel, xdgSurface); });
}

void Compositor::on_toplevel_created(QWaylandXdgToplevel* toplevel, QWaylandXdgSurface* xdgSurface) {
    auto* item = new QWaylandQuickShellSurfaceItem(m_board);

    item->setShellSurface(xdgSurface);
    item->setOutput(m_output);
    item->setInputEventsEnabled(true);
    item->setFocusOnClick(true);
    item->setMoveItem(item);

    m_windows.push_back({toplevel, xdgSurface, item, m_current_workspace});

    QObject::connect(item, &QWaylandQuickShellSurfaceItem::surfaceDestroyed, [this, item] { on_surface_destroyed(item); });
}

void Compositor::on_surface_destroyed(QWaylandQuickShellSurfaceItem* item) {
    for (int i = 0; i < m_windows.size(); i++) {
        if (m_windows[i].item == item) {
            m_windows.erase(m_windows.begin() + i);
            break;
        }
    }

    item->deleteLater();
}
