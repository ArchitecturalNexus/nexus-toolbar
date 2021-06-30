"""Copy/Paste State Base Types"""
#pylint: disable=import-error,invalid-name,broad-except,superfluous-parens
from pyrevit.coreutils import logger
from pyrevit import DB


mlogger = logger.get_logger(__name__)


COPYPASTE_MARKER_PROPNAME = 'is_copypaste_action'

COMPATIBLE_VIEWTYPES = [
    [
        DB.ViewType.FloorPlan,
        DB.ViewType.CeilingPlan,
        DB.ViewType.EngineeringPlan,
        DB.ViewType.AreaPlan
    ]
]


class CopyPasteStateAction(object):
    """Base class for creating Copy/Paste State Actions.

    Example:
        >>>@moduleutils.mark(COPYPASTE_MARKER_PROPNAME)
        >>>class ViewScale(CopyPasteStateAction):
        >>>    name = 'View Scale'
        >>>
        >>>    def copy(self, datafile):
        >>>        view_scale = revit.active_view.Scale
        >>>        datafile.dump(view_scale)
        >>>
        >>>    def paste(self, datafile):
        >>>        view_scale_saved = datafile.load()
        >>>        revit.active_view.Scale = view_scale_saved
        >>>
        >>>    @staticmethod
        >>>    def validate_context():
        >>>        if not isinstance(revit.active_view, DB.TableView):
        >>>            return "Geometrical view must be active. Not a schedule."

    Usage:
        >>>if not ViewScale.validate_context():
        >>>   view_scale_action = ViewScale()
        >>>   view_scale_action.copy()
        ...
        >>>    view_scale_action.paste()
    """
    name = None
    invalid_context_msg = None
    this_project = True

    def copy(self):
        """Performs copy action.

        Args:
            datafile (DataFile): instance of DataFile in `write` mode

        Example:
            >>>def copy(self, datafile):
            >>>    view_scale = revit.active_view.Scale
            >>>    datafile.dump(view_scale)
        """
        pass

    def paste(self):
        """Performs paste action.

        Args:
            datafile (DataFile): instance of DataFile in `read` mode

        Example:
            >>>def paste(self, datafile):
            >>>    view_scale_saved = datafile.load()
            >>>    with revit.Transacction('Paste view scale'):
            >>>        try:
            >>>            revit.active_view.Scale = view_scale_saved
            >>>        except:
            >>>            raise Exception('Cannot paste view scale')
        """
        pass

    @staticmethod
    def validate_context():
        """Validating context before running the action. e.g. if certain view
        type must be active, certail element type selected.
        To be run 'silently', therefore should contain no ui or forms.

        Returns:
            str: message describing the failure; None if validation successful

        Example:
            >>>@staticmethod
            >>>def validate_context():
            >>>    if not isinstance(revit.active_view, DB.TableView):
            >>>        return "Geometrical view must be active. Not a schedule."
        """
        return

    @staticmethod
    def is_compatible_viewtype(target_view, source_viewtype):
        """Check if view types are compatible for this action"""
        if target_view.ViewType == source_viewtype:
            return True

        for compat_viewtypes in COMPATIBLE_VIEWTYPES:
            if target_view.ViewType in compat_viewtypes \
                    and source_viewtype in compat_viewtypes:
                return True

        return False