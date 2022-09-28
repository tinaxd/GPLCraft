#ifndef ChunkRenderer_H
#define ChunkRenderer_H

#include <Godot.hpp>
#include <Spatial.hpp>
#include <MeshInstance.hpp>
#include <Mesh.hpp>

namespace gplcraft
{
    enum : unsigned int
    {
        XNEGF = 1,
        XPOSF = 2,
        YNEGF = 4,
        YPOSF = 8,
        ZNEGF = 16,
        ZPOSF = 32,
    };

    class ChunkRenderer : public godot::Spatial
    {
        GODOT_CLASS(ChunkRenderer, godot::Spatial)

    private:
        godot::Variant chunk_;
        bool dirty_ = false;
        godot::MeshInstance *mesh_instance_;

        void render_chunk();

        godot::Ref<godot::Mesh> generate_mesh();

        bool block_exists(int x, int y, int z);

        godot::Object *get_chunk_obj()
        {
            ERR_MSG_COND(chunk_.get_type() != chunk_.OBJECT);
            godot::Object *obj = chunk_;
            return obj;
        }

    public:
        ~ChunkRenderer();

        static void _register_methods();

        void _init();

        void _ready();

        godot::Variant get_chunk()
        {
            return chunk_;
        }

        void set_chunk(godot::Variant chunk)
        {
            chunk_ = chunk;
            dirty_ = true;
            render_chunk();
        }

        void set_chunk_location(int cx, int cz);
    };

}

#endif
