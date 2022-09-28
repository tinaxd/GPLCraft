using Godot;
using System;

public class Player : Spatial
{
    // Declare member variables here. Examples:
    // private int a = 2;
    // private string b = "text";

    private Camera camera;

    // private Vector2? lastPosition;

    private float cameraAngleX = 0f;
    private float cameraAngleY = 0f;

    // Called when the node enters the scene tree for the first time.
    public override void _Ready()
    {
        camera = GetNode<Camera>("Camera");

        // hide mouse cursor
        Input.MouseMode = Input.MouseModeEnum.Captured;
    }

    // Called every frame. 'delta' is the elapsed time since the previous frame.
    public override void _Process(float delta)
    {
        var inputVelocity = Input.GetVector("move_left", "move_right", "move_forward", "move_back");
        var localInputVelocity = new Vector3(inputVelocity.x, 0, inputVelocity.y);

        var downUpVelocity = Input.GetAxis("move_down", "move_up");

        var localBasis = Transform.basis;
        // var localInputVelocity = localBasis.XformInv(globalInputVelocity);

        // convert to velocity in global coordinate
        var globalInputVelocity = localBasis.Xform(localInputVelocity);
        // set y=0 (prohibit vertical movement)
        globalInputVelocity.y = 0;

        // set magnitude
        var velocity = 5;
        globalInputVelocity = globalInputVelocity.Normalized() * velocity * delta;

        globalInputVelocity.y = downUpVelocity * velocity * delta;

        // convert to back to local coordinate
        localInputVelocity = localBasis.XformInv(globalInputVelocity);

        Translate(localInputVelocity);

        PointerLockCheck();
    }

    private void PointerLockCheck()
    {
        if (Input.IsActionJustPressed("ui_cancel"))
        {
            if (Input.MouseMode == Input.MouseModeEnum.Captured)
            {
                Input.MouseMode = Input.MouseModeEnum.Visible;
            }
            else
            {
                Input.MouseMode = Input.MouseModeEnum.Captured;
            }
        }
    }

    public override void _Input(InputEvent @event)
    {
        if (@event is InputEventMouseMotion motion)
        {
            var d = motion.Relative;

            float ySensitivity = 0.005f;
            float xSensitivity = 0.005f;

            cameraAngleX += xSensitivity * d.x;
            cameraAngleY += ySensitivity * d.y;

            if (cameraAngleX > Mathf.Pi)
            {
                cameraAngleX -= 2 * Mathf.Pi;
            }
            else if (cameraAngleX < -Mathf.Tau)
            {
                cameraAngleX += 2 * Mathf.Pi;
            }

            if (cameraAngleY > Mathf.Pi / 2)
            {
                cameraAngleY = Mathf.Pi / 2;
            }
            else if (cameraAngleY < -Mathf.Pi / 2)
            {
                cameraAngleY = -Mathf.Pi / 2;
            }

            var target = new Vector3()
            {
                x = Mathf.Cos(cameraAngleY) * Mathf.Sin(cameraAngleX),
                y = -Mathf.Sin(cameraAngleY),
                z = -Mathf.Cos(cameraAngleY) * Mathf.Cos(cameraAngleX)
            };

            var trans = this.Transform;
            target += trans.origin;
            trans = trans.LookingAt(target, Vector3.Up);
            this.Transform = trans;
        }
    }
}
