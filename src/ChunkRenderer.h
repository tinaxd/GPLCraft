#ifndef ChunkRenderer_H
#define ChunkRenderer_H

#include <Godot.hpp>
#include <Spatial.hpp>
#include <MeshInstance.hpp>

namespace gplcraft
{

    class ChunkRenderer : public godot::Spatial
    {
        GODOT_CLASS(ChunkRenderer, godot::Spatial)

    private:
        godot::Reference *chunk_ = nullptr;
        bool dirty_ = false;
        godot::MeshInstance *mesh_instance_ = nullptr;

    public:
        static void _register_methods();

        void _init();

        void _ready();
    };

}

#endif
