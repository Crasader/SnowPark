/**
 * Created by IntelliJ IDEA.
 * User: JuzTosS
 * Date: 08.04.12
 * Time: 1:11
 * To change this template use File | Settings | File Templates.
 */
package views
{
import as3isolib.data.INode;
import as3isolib.display.primitive.IsoBox;
import as3isolib.display.primitive.IsoPolygon;
import as3isolib.display.scene.IsoGrid;
import as3isolib.display.scene.IsoScene;
import as3isolib.geom.Pt;

import com.junkbyte.console.Cc;

import flash.events.Event;

import models.IBindableModel;

public class FieldView extends IsoScene
{
    public static const CELL_SIZE:int = 25;

    private static const HEIGHT_MULTIPLIER:Number = -0.7; //Крутизна склона
    private static const HEIGHT_SHIFT:Number = 7; //Точка начала склона

    public function FieldView(model:IBindableModel)
    {
        Cc.addSlashCommand("grid", drawGrid);
    }

    override public function addChild(child:INode):void
    {
        super.addChild(child);
        update();
    }

    public function update(event:Event = null):void
    {
        render();
    }

    private var _grid:IsoGrid;

    public function z(value:int):Number
    {
        var new_z:Number = value * HEIGHT_MULTIPLIER + HEIGHT_SHIFT;
        if (new_z < 0) new_z = 0;
        return new_z;
    }

    private function drawGrid():void
    {
//        if (_grid == null)
//        {
//            _grid = new IsoGrid();
//            _grid.setGridSize(15, 15, 0);
//            _grid.cellSize = CELL_SIZE;
//            this.addChild(_grid);
//        }
        const GRID_SIZE:int = 15;
        for (var x:int = 0; x < GRID_SIZE; x++)
        {
            for (var y:int = 0; y < GRID_SIZE; y++)
            {

                var p:IsoBox = new IsoBox();
                p.setSize(CELL_SIZE, CELL_SIZE, z(x) * CELL_SIZE - CELL_SIZE);
                p.moveTo(x * CELL_SIZE, y * CELL_SIZE, 0)
                addChild(p);
            }
        }

    }
}
}
