#include "ChunkRenderer.h"
#include <SurfaceTool.hpp>

using namespace gplcraft;

void ChunkRenderer::_register_methods()
{
    godot::register_method("_ready", &ChunkRenderer::_ready);
}

void ChunkRenderer::_init()
{
}

void ChunkRenderer::_ready()
{
}

ChunkRenderer::~ChunkRenderer()
{
    if (chunk_ != nullptr)
    {
        chunk_->unreference();
    }
}

void ChunkRenderer::render_chunk()
{
    if (chunk_ == nullptr)
        return;
    if (!dirty_)
        return;

    godot::Ref<godot::MeshInstance> mesh;

    dirty_ = false;
}

constexpr int ALL_FACES = XNEGF | XPOSF | YNEGF | YPOSF | ZNEGF | ZPOSF;

static void add_face(godot::Ref < godot::SurfaceTool st, int faces, int x, int y, int z)
{
}

static void add_faces(godot::Ref<godot::SurfaceTool> st, int faces, int x, int y, int z)
{
    auto f = [faces](int f)
    { return faces & f != 0; };
    if (f(XNEGF))
    {
        add_face(st, XNEGF, x, y, z);
    }
    if (f(XPOSF))
    {
        add_face(st, XPOSF, x, y, z);
    }
    if (f(YNEGF))
    {
        add_face(st, YNEGF, x, y, z);
    }
    if (f(YPOSF))
    {
        add_face(st, YPOSF, x, y, z);
    }
    if (f(ZNEGF))
    {
        add_face(st, ZNEGF, x, y, z);
    }
    if (f(ZPOSF))
    {
        add_face(st, ZPOSF, x, y, z);
    }
}

godot::Ref<godot::Mesh> ChunkRenderer::generate_mesh()
{
    godot::Ref<godot::SurfaceTool> st;
    st.instance();

    st->begin(godot::Mesh::PRIMITIVE_TRIANGLES);
    for (int i = 0; i < 16; i++)
    {
        for (int j = 0; j < 128; j++)
        {
            for (int k = 0; k < 16; k++)
            {
                godot::Array args;
                args.append(i);
                args.append(j);
                args.append(k);
                auto result = chunk_->call("get_block_pos", args);
                ERR_FAIL_COND(result.get_type() != result.OBJECT);
                godot::Object *block = result;
                ERR_FAIL_COND(block == nullptr);

                int block_id = block->get("block_id");
                if (block_id == 0)
                {
                    // air block
                    continue;
                }

                int faces = ALL_FACES;
                if (block_exists(i - 1, j, k))
                {
                    faces &= ~XNEGF;
                }
                if (block_exists(i + 1, j, k))
                {
                    faces &= ~XPOSF;
                }
                if (block_exists(i, j - 1, k))
                {
                    faces &= ~YNEGF;
                }
                if (block_exists(i, j + 1, k))
                {
                    faces &= ~YPOSF;
                }
                if (block_exists(i, j, k - 1))
                {
                    faces &= ~ZNEGF;
                }
                if (block_exists(i, j, k + 1))
                {
                    faces &= ~ZPOSF;
                }
            }
        }
    }
}