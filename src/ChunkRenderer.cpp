#include "ChunkRenderer.h"
#include <SurfaceTool.hpp>
#include <ResourceLoader.hpp>
#include <ArrayMesh.hpp>
#include <Material.hpp>
#include <Transform.hpp>
#include <iostream>

using namespace gplcraft;

void ChunkRenderer::_register_methods()
{
    godot::register_method("_ready", &ChunkRenderer::_ready);
    godot::register_method("set_chunk_location", &ChunkRenderer::set_chunk_location);
    godot::register_property<ChunkRenderer, godot::Variant>("chunk", &ChunkRenderer::set_chunk, &ChunkRenderer::get_chunk, godot::Variant());
}

void ChunkRenderer::_init()
{
}

void ChunkRenderer::_ready()
{
    mesh_instance_ = godot::MeshInstance::_new();
    add_child(mesh_instance_);
}

ChunkRenderer::~ChunkRenderer()
{
    delete mesh_instance_;
    mesh_instance_ = nullptr;
}

void ChunkRenderer::render_chunk()
{
    std::cout << "render_chunk (C++) is called" << std::endl;
    if (chunk_.get_type() == chunk_.NIL)
    {
        std::cout << "chunk is null" << std::endl;
        return;
    }
    if (!dirty_)
        return;

    std::cout << "chunk is dirty, rendering..." << std::endl;

    auto mesh = generate_mesh();

    auto block_material = godot::ResourceLoader::get_singleton()->load("res://Materials/BlockMaterial.tres");

    mesh_instance_->set_mesh(mesh);
    mesh_instance_->set_material_override(block_material);

    dirty_ = false;
}

constexpr unsigned int ALL_FACES = XNEGF | XPOSF | YNEGF | YPOSF | ZNEGF | ZPOSF;

static void _av(godot::Ref<godot::SurfaceTool> st, int x, int y, int z, int bx, int by, int bz, godot::Vector3 normal, int ux, int uy)
{
    float uxf = (16.0 / 256.0) * (2 + (1 - ux));
    float uyf = (16.0 / 256.0) * (15 + (1 - uy));
    st->add_uv(godot::Vector2(uxf, uyf));
    st->add_normal(normal);
    st->add_vertex(godot::Vector3(x + bx, y + by, z + bz));
}

static void add_face(godot::Ref<godot::SurfaceTool> s, int face, int x, int y, int z)
{
    switch (face)
    {
    case XPOSF:
    {
        auto norm = godot::Vector3(1, 0, 0);
        _av(s, 1, 0, 1, x, y, z, norm, 0, 1);
        _av(s, 1, 1, 1, x, y, z, norm, 1, 1);
        _av(s, 1, 1, 0, x, y, z, norm, 1, 0);

        _av(s, 1, 1, 0, x, y, z, norm, 1, 0);
        _av(s, 1, 0, 0, x, y, z, norm, 0, 0);
        _av(s, 1, 0, 1, x, y, z, norm, 0, 1);
        break;
    }
    case YNEGF:
    {
        auto norm = godot::Vector3(0, -1, 0);
        _av(s, 0, 0, 1, x, y, z, norm, 0, 1);
        _av(s, 1, 0, 1, x, y, z, norm, 1, 1);
        _av(s, 1, 0, 0, x, y, z, norm, 1, 0);

        _av(s, 1, 0, 0, x, y, z, norm, 1, 0);
        _av(s, 0, 0, 0, x, y, z, norm, 0, 0);
        _av(s, 0, 0, 1, x, y, z, norm, 0, 1);
        break;
    }
    case XNEGF:
    {
        auto norm = godot::Vector3(-1, 0, 0);
        _av(s, 0, 1, 1, x, y, z, norm, 0, 1);
        _av(s, 0, 0, 1, x, y, z, norm, 1, 1);
        _av(s, 0, 0, 0, x, y, z, norm, 1, 0);

        _av(s, 0, 0, 0, x, y, z, norm, 1, 0);
        _av(s, 0, 1, 0, x, y, z, norm, 0, 0);
        _av(s, 0, 1, 1, x, y, z, norm, 0, 1);
        break;
    }
    case YPOSF:
    {
        auto norm = godot::Vector3(0, 1, 0);
        _av(s, 1, 1, 1, x, y, z, norm, 0, 1);
        _av(s, 0, 1, 1, x, y, z, norm, 1, 1);
        _av(s, 0, 1, 0, x, y, z, norm, 1, 0);

        _av(s, 0, 1, 0, x, y, z, norm, 1, 0);
        _av(s, 1, 1, 0, x, y, z, norm, 0, 0);
        _av(s, 1, 1, 1, x, y, z, norm, 0, 1);
        break;
    }
    case ZPOSF:
    {
        auto norm = godot::Vector3(0, 0, 1);
        _av(s, 0, 1, 1, x, y, z, norm, 0, 1);
        _av(s, 1, 1, 1, x, y, z, norm, 1, 1);
        _av(s, 1, 0, 1, x, y, z, norm, 1, 0);

        _av(s, 1, 0, 1, x, y, z, norm, 1, 0);
        _av(s, 0, 0, 1, x, y, z, norm, 0, 0);
        _av(s, 0, 1, 1, x, y, z, norm, 0, 1);
        break;
    }
    case ZNEGF:
    {
        auto norm = godot::Vector3(0, 0, -1);
        _av(s, 0, 0, 0, x, y, z, norm, 0, 1);
        _av(s, 1, 0, 0, x, y, z, norm, 1, 1);
        _av(s, 1, 1, 0, x, y, z, norm, 1, 0);

        _av(s, 1, 1, 0, x, y, z, norm, 1, 0);
        _av(s, 0, 1, 0, x, y, z, norm, 0, 0);
        _av(s, 0, 0, 0, x, y, z, norm, 0, 1);
        break;
    }
    }
}

static void add_faces(godot::Ref<godot::SurfaceTool> st, int faces, int x, int y, int z)
{
    auto f = [faces](int face)
    { return (faces & face) != 0; };
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
    auto chunk_obj = get_chunk_obj();
    int count = 0;
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
                auto result = chunk_obj->call("get_block_pos", args);
                ERR_MSG_COND(result.get_type() != result.OBJECT);
                godot::Object *block = result;
                ERR_MSG_COND(block == nullptr);

                int block_id = block->get("block_id");
                if (block_id == 0)
                {
                    // air block
                    continue;
                }

                count++;
                unsigned int faces = ALL_FACES;
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
                std::cerr << faces << std::endl;
                add_faces(st, faces, i, j, k);
            }
        }
    }
    std::cerr << "calculated " << count << " blocks" << std::endl;

    return st->commit();
}

bool ChunkRenderer::block_exists(int x, int y, int z)
{
    if (x < 0 || x >= 16 || y < 0 || y >= 128 || z < 0 || z >= 16)
    {
        return false;
    }

    godot::Array args;
    args.resize(3);
    args[0] = x;
    args[1] = y;
    args[2] = z;
    auto o = get_chunk_obj()->call("get_block_pos", args);
    ERR_MSG_COND(o.get_type() != o.OBJECT);

    godot::Object *block = o;
    ERR_MSG_COND(block == nullptr);

    auto block_id_v = block->get("block_id");
    ERR_MSG_COND(block_id_v.get_type() != block_id_v.INT);
    int block_id = block_id_v;
    // std::cerr << block_id << std::endl;
    return block_id != 0;
}

void ChunkRenderer::set_chunk_location(int cx, int cz)
{
    dirty_ = true;
    auto t = godot::Transform::IDENTITY;
    auto t2 = t.translated(godot::Vector3(cx * 16, 0, cz * 16));
    set_transform(t2);
}